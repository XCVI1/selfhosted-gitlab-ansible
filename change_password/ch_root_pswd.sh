#!/bin/bash

echo "Wait about one minute after write in"

docker exec -it gitlab bash -c "gitlab-rake 'gitlab:password:reset[root]'"

docker exec gitlab gitlab-ctl restart

echo "Done!"
