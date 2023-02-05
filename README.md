# filebeat-caprover

Filebeat config for Nginx and other logs in Caprover Docker containers. This guide helps you to setup Filebeat to collect nginx and other logs on your Caprover instance then sends them to your elastic / kibana instances.

I had diffuculties and spend a few hours while integrating filebeat to my caprover instance, so I hope this helps someone!

Filebeat helps you to read log files and send them to Elastic search & Kibana instances on your servers. Useful for monitoring your apps on Caprover.

This guide assumes you already have;

 - Running Caprover instance
 - ElasticSearch app on your Caprover
 - Kibana app on your Caprover

If any of the above are missing, this guide is not for you.

Lets begin!

1) Open your Caprover panel and go to "Apps"
2) On the create a new app panel, write a name for filebeat instance
3) Make sure you've selected the "Has Persistent Data" option

Should look like this:

<img width="714" alt="New Filebeat App Creation" src="https://user-images.githubusercontent.com/6469914/216827007-b50b437a-4934-4cef-b39b-be63c1642084.png">

4) Click to newly created app and go to app settings.
5) Check "Do not expose as web-app" for security, we'll not use it from outside.

Should look like this:

<img width="1000" alt="App without exposing itself to the web" src="https://user-images.githubusercontent.com/6469914/216827052-eac3857d-b61d-4f26-b57c-5ff98aaa98aa.png">

6) Go to App Configs page
7) Add following environment variables for your Elastic search and Kibana instances. 
(You can find the HTTP URLS from your apps main page.)

| **key**      | **value**                            | **example**                      |
|--------------|--------------------------------------|----------------------------------|
| KIBANA_HOST  | your kibana host                     | http://srv-captain--kibana       |
| ELASTIC_HOST | your elastic host with internal port | http://srv-captain--elastic:9200 |


Should look like this:

<img width="1000" alt="Configs" src="https://user-images.githubusercontent.com/6469914/216827296-532b641e-023a-48a3-9fb4-302ec8526e62.png">

8) Click add persistent data/directory button, and click to "Set specific host" option. 

We'll open some docker directories to let our docker container to read other container logs from our docker host server. 

Add following values

| **Path in App**            | **Path in Host**           |
|----------------------------|----------------------------|
| /var/lib/docker/containers | /var/lib/docker/containers |
| /var/run/docker.sock       | /var/run/docker.sock       |

Should look like this: 

<img width="1000" alt="Configs" src="https://user-images.githubusercontent.com/6469914/216827645-918fba2c-5ffa-4d5e-8baf-d7d19b102148.png">


9) Go to pre deploy script and paste the following function. Make sure you have changed username to your host docker runner username. (root in my case). 
This script lets our docker container to access related logs files we specified in previous steps with correct credentials. Otherwise our docker container cannot access the logs even if we gave them as persistent directory. (You can also create a user group for this, we just need to give permissions somehow :))

```js
var preDeployFunction = function (captainAppObj, dockerUpdateObject) {
    return Promise.resolve()
        .then(function(){
            dockerUpdateObject.TaskTemplate.ContainerSpec.User = 'yourusername';
            return dockerUpdateObject;
        });
};

```

Should look like this:

<img width="1000" alt="Caprover predeploy function" src="https://user-images.githubusercontent.com/6469914/216827417-4ecb53dc-42d9-4828-87be-2cd2222e7f6e.png">

10) Click to Save & Update button on the bottom.
11) App Configuration is done! Now we need deployment.
12) You can use this repository for easy deployment, clone or fork this repo to your local computer.
13) If you want to change filebeat.yml file, make changes. Currently it is optimized for nginx configurations.
14) Go to the related folder in terminal
15) Use caprover deploy command (check the docs if you didn't make any deployment before)

You should see a similar output

<img width="1000" alt="Deploy output" src="https://user-images.githubusercontent.com/6469914/216827503-b0ae3ea8-05a2-48b3-a590-c3f4561738e5.png">


16) It is ready! Go to your kibana public url and observe the logs!

<img width="1000" alt="Kibana is ready" src="https://user-images.githubusercontent.com/6469914/216827531-5f679dda-9597-4395-9644-bd7fb410c7e1.png">



17) Optional: close kibana/elastic nginx logs by adding acces_logs: off to nginx config of the kibana/elastic apps to prevent logging your actions on kibana to kibana :))


