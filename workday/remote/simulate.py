import numpy as np
import json
import time

import schedule
import argparse

from itertools import chain
from multiprocessing import Pool
from datetime import datetime
from math import floor 

from kafka import KafkaProducer

from faker import Faker
fake = Faker()

# generate a series of users and activity events over the course of the days

weekdays = range(1,6)
alldays = range(0,7)

user_types = [{ 
    "workdays": weekdays,
    "hours": ("09:00", "17:00"),
    "timezone": "GMT",
    "profile": "user",
    "activity_level": 0.03,
    "out_of_hours": 0.01
},{ 
    "workdays": alldays,
    "hours": ("00:00", "23:59"),
    "timezone": "GMT",
    "profile": "system",
    "activity_level": 0.01,
    "out_of_hours": 0.0
},{ 
    "workdays": weekdays,
    "hours": ("09:00", "17:00"),
    "timezone": "EST",
    "profile": "user",
    "activity_level": 0.01,
    "out_of_hours": 0.005
}]

departments = ["Account", "IT", "Sales", "HR", "Marketing", "Corporate", "SysAdmin"]

def do_upload(extra, user):
    extra.update({
        'topic': 'http',
        'ip_dst_addr': fake.ipv4_public(),
        'ip_src_addr': user['ip'],
        'ip_src_port': fake.random_int(1025, 60000), #fake.random.nextInt(1024,65500),
        'ip_dst_port': 80,
        'url': fake.uri(),
        'method': 'POST',
        'bytes': np.random.randint(512, 105 * 1024),
        'request-length':  np.random.randint(512, 105 * 1024),
        'user-agent': user['user_agent']
        })
    return extra 


def do_http(extra, user): 
    extra.update({
        'topic': 'http',
        'ip_dst_addr': fake.ipv4_public(),
        'ip_src_addr': user['ip'],
        'ip_src_port': fake.random_int(1025, 60000), #fake.random.nextInt(1024,65500),
        'ip_dst_port': 80,
        'url': fake.uri(),
        'method': 'GET',
        'bytes': np.random.randint(512, 105 * 1024),
        'user-agent': user['user_agent']
        })
    return extra 

def do_email(extra, user): 
    a = user['email']
    b = fake.email() if np.random.random() < 0.8 else fake.free_email()
    r = np.random.random() < 0.25
    extra.update({
        'topic': 'email',
        'from': a if r else b,
        'to': b if r else a,
        'subject': fake.sentences(nb = 1),
        'body': "\n".join(fake.paragraphs(nb=np.random.randint(5, 20), ext_word_list=None))
        })
    return extra 

def do_auth(extra, user): 
    # do things like login, browse web sites etc 
    extra.update({
        'topic': 'auth',
        'ip_dst_addr': fake.ipv4(network=False, address_class="c", private=True),
        'ip_src_addr': user['ip'],
        'action': 'Login',
        'result': ('success' if np.random.random() < 0.90 else 'failed')
        })
    return extra 

# events on every tick based on the probabilities in the user array
# activity nature is from the profile

def make_host():
    return {}

def make_users(type): 
    name = fake.name() if type['profile'] != "system" else "System " + str(np.random.randint(0,1000))
    username = (name.split(" ")[0][0] + name.split(" ")[1]).lower()
    department = fake.random_element(departments)
    
    return { "name": name,
        "username": username if type['profile'] != "system" else username.upper(),
        "email": username + "@hortonworks.com",
        "department": department,
        "user_type": type,
        "ip": fake.ipv4(network=False, address_class="c", private=True),
        "user_agent": fake.user_agent(),
        "job": fake.job()
    }

def random_user_type(bias):
    u = np.random.choice(user_types, p = bias)
    if (isinstance(u['hours'][0], str)): 
        u['hours'] = list(map(lambda t: datetime.strptime(t, "%H:%M"), u['hours']))
    return u
    
users = [make_users(random_user_type([0.7,0.1,0.2])) for u in range(1,50)]
host = [make_host() for u in range(1,10)]

login_status = {}

def flatmap(f, items):
    return chain.from_iterable(imap(f, items))

def tick(time):
    ts = time.timestamp()
    # for each user, determine if there is an action, and what that action might be
    lt = time.strptime(time.strftime("%H:%M"), "%H:%M")
    
    def in_hours(hours, workdays):
        return (lt >= hours[0] and lt <= hours[1] and time.weekday() in workdays)

    def user_tick(user):
        func = np.random.choice([do_upload, do_http, do_email], p=[0.1,0.6,0.3])
        if np.random.random() < (user['user_type']['activity_level'] if in_hours(user['user_type']['hours'], user['user_type']['workdays']) else user['user_type']['out_of_hours']):
            return func({
                'timestamp': floor(time.timestamp() * 1000),
                'user': user['username']
                }, user)

    return list(filter(non_none, map(user_tick,np.random.choice(users, 10))))


def pool_filter(pool, func, candidates):
    return [c for c, keep in zip(candidates, p.map(func, candidates)) if keep]

def non_none(f):
    return f != None and len(f) > 0

#p = Pool(8)
#start = datetime(2018, 4, 19, 0, 0, 0).timestamp()
#ticks = [datetime.fromtimestamp(t) for t in range(int(start + (60 * 60 * 9)), int(start + (60 * 60 * 20)), 1)]
#res = list(chain(*pool_filter(p, non_none, p.map(tick, ticks))))
#print(json.dumps(res))

parser = argparse.ArgumentParser(description='Generate random data.')
parser.add_argument('-k', '--bootstrap-servers', type=str, help='Kafka servers')
parser.add_argument('-i', '--interval', type=float, help='Tick interval')
args = parser.parse_args()

if (args.bootstrap_servers):
    producer = KafkaProducer(bootstrap_servers=args.bootstrap_servers, value_serializer=lambda v: json.dumps(v).encode('utf-8'))

def ticker():
    for a in filter(non_none, [tick(datetime.now()) for i in range(1,10)]):
        for m in a:
            if args.bootstrap_servers:
                producer.send(m['topic'], m)
            else:
                print(json.dumps(m))

schedule.every(args.interval).seconds.do(ticker)
while 1:
    schedule.run_pending()
    time.sleep(1)
