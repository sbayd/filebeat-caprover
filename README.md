# filebeat-caprover
Filebeat config for nginx and other logs in caprover docker containers.

This guide helps you to setup Filebeat to collect nginx and other logs on your Caprover instance. then sends them to your elastic / kibana instances.

Useful for monitoring your apps on Caprover.

This guide assumes you already have elastic search / kibana instances on your Caprover instance.

Lets begin!

1) Open your Caprover panel and go to "Apps"
2) On the create a new app panel, write a name for filebeat instance
3) Make sure you've selected the "Has Persistent Data" option
4) Click to newly created app and go to app settings.
5) Check "Do not expose as web-app" for security, we'll not use it from outside.
6) Go to App Configs page
7) Add following environment variables for your Elastic search and Kibana instances. You can find the HTTP URLS from your apps main page.
    key: KIBANA_HOST, value: your kibana host(in my case: http://srv-captain--kibana1)
    key: ELASTIC_HOST, value: your elastic host with internal port (in my case: http://srv-captain--elastic-1:9200)
8) Click add persistent data/directory button, and click to "Set specific host" option. We'll make same directory mapping to let our docker container to read other container logs from our docker host server. Add following values
    Path in App: /var/lib/docker/containers
    Path on Host: /var/lib/docker/containers
    Path in App: /var/run/docker.sock
    Path on Host: /var/run/docker.sock
9) Go to pre deploy script and paste the following function. Make sure you have changed username to your host docker runner username. (root in my case). 
This script lets our docker container to access related logs files we specified in previous steps with correct credentials. Otherwise our docker container cannot access the logs even if we gave them as persistent directory. (You can also create a user group for this, we just need to give permissions somehow :))

```
var preDeployFunction = function (captainAppObj, dockerUpdateObject) {
    return Promise.resolve()
        .then(function(){
            dockerUpdateObject.TaskTemplate.ContainerSpec.User = '#yourusername';
            return dockerUpdateObject;
        });
};


```

10) Click to save button
11) Go to the deployment tab
12) You can use this repository for easy deployment, clone or fork this repo to your local computer.
13) If you want to change filebeat.yml file, make changes. Currently it is optimized for nginx configurations.
14) Go to the related folder in terminal
15) use caprover deploy command
16) It is ready! Go to your kibana public url and observe the logs!






