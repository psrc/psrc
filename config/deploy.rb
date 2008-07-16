set :application, "set your application name here"
set :repository,  "set your repository location here"

set :deploy_to, "/sites/psrc"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git

role :app, "pinkpucker.net"
role :web, "pinkpucker.net"
role :db,  "pinkpucker.net", :primary => true
