JBoss BPM Suite Mortgage Demo 
=============================
The example project mortgage demo that is delivered with the JBoss BPM product.

There are three options available to you for using this demo; local, OpenShift and Docker.


Option 1 - Install on your machine
----------------------------------
1. [Download and unzip.](https://github.com/jbossdemocentral/bpms-mortgage-demo/archive/master.zip)

2. Add products to installs directory.

3. Run 'init.sh' or 'init.bat' file. 'init.bat' must be run with Administrative privileges. 

4. Start JBoss BPMS Server by running 'standalone.sh' or 'standalone.bat' in the <path-to-project>/target/jboss-eap-6.1/bin directory.

5. Login to http://localhost:8080/business-central  

    ```
    - login for admin, appraisor, broker, and manager roles (u:erics / p:bpmsuite1!)
    ```

6. Mortgage Loan demo pre-installed as project.

7. Process and Task dashboard pre-filled with mock data optional now. 

8. You can pre-load the BPM Suite Mortgage project with multiple pre-configured process instances, some will run through the
rejected path, some will be waiting for you in the various human task when you login. To inject these pre-configured
requests just run the client jar from a command line shell. You can run the following command from the 'support' directory:

    ```
   java -jar jboss-mortgage-demo-client.jar erics bpmsuite1!
    ```


Option 2 - Install with one click in xPaaS (bpmPaaS)
----------------------------------------------------
After clicking button, ensure `Gear` size is set to `medium`:

[![Click to install OpenShift](http://launch-shifter.rhcloud.com/launch/light/Install bpmPaaS.svg)](https://openshift.redhat.com/app/console/application_type/custom?&cartridges[]=https://raw.githubusercontent.com/jbossdemocentral/cartridge-bpmPaaS-mortgage-demo/master/metadata/manifest.yml&name=bpmpaasmortgage&gear_profile=medium&initial_git_url=)

Once installed you can use the JBoss BPM Suite logins: 

   * u:erics   p: bpmsuite  (admin)

   * u: alan   p: bpmsuite  (analyst)

   * u: daniel p: bpmsuite (developer)

   * u: ursla  p: bpmsuite (user)

   * u: mary   p: bpmsuite (manager)



Option 3 - Generate docker install
----------------------------------
The following steps can be used to configure and run the demo in a docker container

1. [Download and unzip.](https://github.com/jbossdemocentral/bpms-mortgage-demo/archive/master.zip)

2. Add product installer to installs directory.

3. Copy contents of support/docker directory to the project root.

4. Build demo image.

	```
	docker build -t jbossdemocentral/bpms-mortgage-demo .
	```
5. Start demo container.

	```
	docker run --it -p 8080:8080 -p 9990:9990 jbossdemocentral/bpms-mortgage-demo
	```
6. Login to http://localhost:8080/business-central  

    ```
    - login for admin, appraisor, broker, and manager roles (u:erics / p:bpmsuite1!)
    ```

7. Mortgage Loan demo pre-installed as project.

8. Process and Task dashboard pre-filled with mock data optional now. 

9. You can pre-load the BPM Suite Mortgage project with multiple pre-configured process instances, some will run through the
rejected path, some will be waiting for you in the various human task when you login. To inject these pre-configured
requests just run the client jar from a command line shell. You can run the following command inside your container from the '/opt/jboss/support' directory:

    ```
   java -jar jboss-mortgage-demo-client.jar erics bpmsuite1!
    ```

Additional information can be found in the jbossdemocentral docker [developer repository](https://github.com/jbossdemocentral/docker-developer)


Notes
-----
The following functionality is covered:

- One advanced process.

- Four Human Tasks assigned to 3 different roles

- Use of Swimlanes to assign a task to the user who previously took ownership

- Several guide business rules

- Several technical rules

- A guided web decision table

- Several Script Tasks for Java work

- One Web Service task using SOAP/HTTP

- Exclusive use of the BPMS Data Modeler for creating the Java fact model

- Use of graphic form designer to create 4 forms with an example of javascript validation

- Helper jar to pre-load with sixteen process instances in various states.

For 'Appraisal' task only, any claimed tasks that are not competed within a minute will be reassigned automatically back into the group for processing.

Note that the entire demo is running default in memory, restart server, lose your process instances, data, monitoring history.

Sources for the demo client jar can be found in the projects directory.


Supporting Articles
-------------------
[3 shockingly easy ways into JBoss rules, events, planning & BPM](http://www.schabell.org/2015/01/3-shockingly-easy-ways-into-jboss-brms-bpmsuite.html)

[Jump Start Your Rules, Events, Planning and BPM Today](http://www.schabell.org/2014/12/jump-start-rules-events-planning-bpm-today.html)

[5 Handy Tips From JBoss BPM Suite For Release 6.0.3](http://www.schabell.org/2014/10/5-handy-tips-from-jboss-bpmsuite-release-603.html)

[Rocket into the Clouds with OpenShift bpmPaaS Quickstarts](http://www.schabell.org/2014/10/red-hat-openshift-bpmpaas-automated-demo-projects-updated.html)

[Red Hat JBoss BPM Suite - all product demos updated for version 6.0.2.GA release](http://www.schabell.org/2014/07/redhat-jboss-bpmsuite-product-demos-6.0.2-updated.html)

[Red Hat JBoss BPM Suite - installing the Mortgage demo project (video)] (http://www.schabell.org/2013/10/jboss-bpm-suite-install-mortage-demo-video.html)

[Red Hat JBoss BPM Suite - get rocking with the all new Mortgage Demo] (http://www.schabell.org/2013/10/jboss-bpm-suite-rocking-the-mortgage-demo.html)


Released versions
-----------------
See the tagged releases for the following versions of the product:

- v1.9 - JBoss BPM Suite 6.0.3 with automated task reassignment.

- v1.8 - JBoss BPM Suite 6.0.3 with optional docker installation.

- v1.7 - moved to JBoss Demo Central, updated windows init.bat support and one click install button.
 
- v1.6 - JBoss BPM Suite 6.0.3 installer with mortgage demo installed.

- v1.5 - JBoss BPM Suite 6.0.2 installer used, with mortgage demo installed and demo client jar sources added.

- v1.4 - JBoss BPM Suite 6.0.2 installer used, with mortgage demo installed.

- v1.3 - JBoss BPM Suite 6.0.2, JBoss EAP 6.1.1, and mortgage demo installed.

- v1.2 - JBoss BPM Suite 6.0.1, JBoss EAP 6.1.1, and mortgage demo installed.

- v1.1 - JBoss BPM Suite 6.0.0, JBoss EAP 6.1.1, and mortgage demo installed, mock data question removed.

- v1.0 - JBoss BPM Suite 6.0.0, JBoss EAP 6.1.1, and mortgage demo installed.

- v0.7 - JBoss BPM Suite 6.0.0.CR2, JBoss EAP 6.1.1, and mortgage demo installed.

- v0.6 - JBoss BPM Suite 6.0.0.CR1, JBoss EAP 6.1.1, and mortgage demo installed, optional mock data population.

- v0.5 - JBoss BPM Suite 6.0.0.CR1, JBoss EAP 6.1.1, and mortgage demo installed, optional mock data population.

- v0.4 - JBoss BPM Suite 6.0.0.Beta, JBoss EAP 6.1.1, mock data populated in Process and Task dashboard, and mortgage demo installed.

- v0.3 - JBoss BPM Suite 6.0.0.Beta1, JBoss EAP 6.0, and mortgage demo installed.

- v0.2 - JBoss BPM Suite ER4, JBoss EAP 6.0, new roles assignment, and mortgage demo installed.

- v0.1 - JBoss BPM Suite ER3, JBoss EAP 6.0, and mortgage demo installed.


![Mortgage Process](https://github.com/jbossdemocentral/bpms-mortgage-demo/blob/master/docs/demo-images/mortgage-process.png?raw=true)

![Process and Task Dashboard](https://github.com/jbossdemocentral/bpms-mortgage-demo/blob/master/docs/demo-images/mock-bpm-data.png?raw=true)

