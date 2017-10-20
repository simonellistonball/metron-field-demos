import sys, json

new_profiles = json.load(sys.stdin)

def make_op(p):
    return { 
        'op': 'add',
        'path': '/profiles/-',
        'value': p
    }

patch = map(make_op, new_profiles['profiles'])
print(json.dumps(patch))
