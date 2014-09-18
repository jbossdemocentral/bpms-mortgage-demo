JBoss BPM Suite Mortgage Demo - demo client sources 
==================================================


Quickstart
----------

1. Run `mvn clean install` here to build the client jar in the generated target directory.

2. This is provided as a code example for how to inject instances into your process projects, a pre-built version is available in
	 the support directory:

   ```
   You can pre-load the BPM Suite Mortgage project with multiple pre-configured process instances, some will run through the
   rejected path, some will be waiting for you in the various human task when you login. To inject these pre-configured
   requests just run the client jar from a command line shell. You can run the following command from the 'support' directory:

   java -jar jboss-mortgage-demo-client.jar erics bpmsuite1!
   ```

