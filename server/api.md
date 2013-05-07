url: 	/api/init
query:	u,app,box
sample: /api/init?u=x@x.com&app=test&box=centos
ack:	{status:200} - ok
		{status:500} - user operation not permitted if user is not in white domain
		{status:501} - app name existed
		{status:502} - box not found

url:	/api/destroy
query:  u,app
sample: /api/destroy?u=x@x.com&app=test
ack:	{status:200} - ok
		{status:500} - user operation not permitted if user is not owner
		{status:501} - app not found

url:	/api/list
query:	u
sample: /api/list?u=x@x.com
ack:	{status:200, 
			apps:[
				{name:'test', dns:'test.diors.it', ip:'x.x.x.x', owner:'x@x.com', status:'running'},
				{name:'test2', dns:'test2.diors.it', ip:'x.x.x.x', owner:'x@x.com', status:'down'}
				]
		}

url:	/api/app/user/add
query:	u,app,adduser
sample: /api/app/user/add?u=x@x.com&app=test&adduser=y@y.com
ack:	{status:200} - ok
		{status:500} - user operation not permitted if user is not owner
		{status:501} - app not found
		{status:502} - add user invalid if not in white domain
		{status:503} - add user existed

url:	/api/app/user/del
query: 	u,app,deluser
sample:	/api/app/user/del?u=x@x.com&app=test
ack:	{status:200} - ok
		{status:500} - user operation not permitted if user is not owner
		{status:501} - app not found
		{status:502} - del user not found

url:	/api/app/user/list
query:	u,app
sample: /api/app/user/list?u=x@x.com&app=test
ack:	{status:200, users:[{name:'x@x.com', role:'owner'},{name:'y@y.com', role:'member'}]}
		{status:500} - app not found

url:	/api/app/inst/up
query: 	u,app
sample: /api/app/inst/up?u=x@x.com&app=test
ack:	{status:200} - ok
		{status:500} - user operation not permitted if user is not owner or member
		{status:501} - app not found
		{status:502} - app is already running

url:	/api/app/inst/halt
query: 	u,app
sample: /api/app/inst/halt?u=x@x.com&app=test
ack:	{status:200} - ok
		{status:500} - user operation not permitted if user is not owner or member
		{status:501} - app not found
		{status:502} - app is already suspended or halted

url:	/api/app/inst/suspend
query: 	u,app
sample: /api/app/inst/suspend?u=x@x.com&app=test
ack:	{status:200} - ok
		{status:500} - user operation not permitted if user is not owner or member
		{status:501} - app not found
		{status:502} - app is already suspended or halted

url:	/api/app/ssh/passwd
query:	u,app
sample:	/api/app/ssh/passwd?u=x@x.com&app=test
ack:	{status:200, passwd:'xxx'} - ok
		{status:500} - user operation not permitted if user is not owner or member
		{status:501} - app not found

url:	/api/app/ssh/bindkey
query:	u,app,key
sample: /api/app/ssh/bindkey?u=x@x.com&app=test&key=xxx
ack:	{status:200} - ok
		{status:500} - user operation not permitted if user is not owner or member
		{status:501} - app not found
