package com.redhat.bpms.examples.mortgage;

import static org.junit.Assert.*;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;
import javax.xml.bind.DatatypeConverter;

import org.apache.http.client.ResponseHandler;
import org.apache.http.client.fluent.Request;
import org.apache.http.client.fluent.Response;
import org.apache.http.entity.ContentType;
import org.junit.Test;
import org.kie.api.runtime.KieSession;
import org.kie.api.runtime.manager.RuntimeEngine;
import org.kie.services.client.api.RemoteRestRuntimeEngineFactory;
import org.kie.services.client.serialization.jaxb.impl.deploy.JaxbDeploymentJobResult;

public class CreateProcesses
{

    @Test
    public void runFromTestMethod() {
        main(new String []{"erics", "bpmsuite1!"});
    }

	public static void main(String[] args)
	{
		if( args.length < 2 || args.length > 4 )
		{
			System.out
					.println( "Usage: java -jar jboss-mortgage-demo-client.jar username password [http://localhost:8080/business-central [com.redhat.bpms.examples:mortgage:1]]" );
			return;
		}

		String userId = args[0];
		String password = args[1];

		String applicationContext;
		if( args.length > 2 )
		{
			applicationContext = args[2];
		}
		else
		{
			applicationContext = "http://localhost:8080/business-central";
		}

		String deploymentId;
		if( args.length > 3 )
		{
			deploymentId = args[3];
		}
		else
		{
			deploymentId = "com.redhat.bpms.examples:mortgage:1";
		}

		deployProject( userId, password, applicationContext, deploymentId );

		populateSamples( userId, password, applicationContext, deploymentId );
	}

    private static void deployProject( String userId, String password, String applicationContext, String deploymentId ) {

        String uriStr = applicationContext + "/rest/deployment/" + deploymentId + "/deploy";

        Request request = Request.Get(uriStr)
                .addHeader(HttpHeaders.ACCEPT, MediaType.APPLICATION_XML.toString())
                .addHeader(HttpHeaders.AUTHORIZATION, basicAuthenticationHeader(userId, password));

        ResponseHandler<JaxbDeploymentJobResult> rh = new XmlResponseHandler(ContentType.APPLICATION_XML, 202, JaxbDeploymentJobResult.class);

        Response resp = null;
        try {
            resp = request.execute();
        } catch( Exception e ) {
            String msg = "Unable to GET " + uriStr + ": " + e.getMessage();
            System.err.println(msg);
            e.printStackTrace();
            fail(msg);
        }

        JaxbDeploymentJobResult jobResult = null;
        try {
            jobResult =  resp.handleResponse(rh);
        } catch( Exception e ) {
            String msg = "Failed retrieving response from [GET] " + uriStr;
            System.err.println(msg);
            e.printStackTrace();
            fail(msg);
        }

        // Eric: I have code to check on the deployment status
        // (I have a whole class for this in the internal test suite)
        // but I'm not going to copy/paste that here.
        // I guess I need to create a kie-remote-client REST deploy API Java client? Hmm..
        // Another thing for 7.0!

        // instead of checking on the job, we just wait 15 secs
        try {
            Thread.sleep(15 *1000);
        } catch( InterruptedException e ) {
            // no-op
        }
    }

    private static String basicAuthenticationHeader( String user, String password ) {
        String token = user + ":" + password;
        try {
            return "BASIC " + DatatypeConverter.printBase64Binary(token.getBytes("UTF-8"));
        } catch( UnsupportedEncodingException ex ) {
            throw new IllegalStateException("Cannot encode with UTF-8", ex);
        }
    }

	public static void populateSamples(String userId, String password, String applicationContext, String deploymentId)
	{
		RuntimeEngine runtimeEngine = getRuntimeEngine( applicationContext, deploymentId, userId, password );
		KieSession kieSession = runtimeEngine.getKieSession();
		Map<String, Object> processVariables;
		//qualify with very low interest rate, great credit, non-jumbo loan
		processVariables = getProcessArgs( "Amy", "12301 Wilshire", 333224449, 100000, 500000, 100000, 30 );
		kieSession.startProcess( "com.redhat.bpms.examples.mortgage.MortgageApplication", processVariables );
		//qualify with very low interest rate, great credit, non-jumbo loan
		processVariables = getProcessArgs( "Andy", "12302 Wilshire", 333224449, 100000, 500000, 100000, 30 );
		kieSession.startProcess( "com.redhat.bpms.examples.mortgage.MortgageApplication", processVariables );
		//qualify with low interest rate, good credit, non-jumbo loan
		processVariables = getProcessArgs( "John", "12303 Wilshire", 333224446, 100000, 500000, 100000, 30 );
		kieSession.startProcess( "com.redhat.bpms.examples.mortgage.MortgageApplication", processVariables );
		//qualify with low interest rate, good credit, non-jumbo loan
		processVariables = getProcessArgs( "Jane", "12304 Wilshire", 333224446, 100000, 500000, 100000, 30 );
		kieSession.startProcess( "com.redhat.bpms.examples.mortgage.MortgageApplication", processVariables );
		//qualify with lower interest rate, great credit, jumbo loan
		processVariables = getProcessArgs( "Liz", "12305 Wilshire", 333224449, 200000, 1000000, 200000, 30 );
		kieSession.startProcess( "com.redhat.bpms.examples.mortgage.MortgageApplication", processVariables );
		//qualify with lower interest rate, great credit, jumbo loan
		processVariables = getProcessArgs( "Larry", "12306 Wilshire", 333224449, 200000, 1000000, 200000, 30 );
		kieSession.startProcess( "com.redhat.bpms.examples.mortgage.MortgageApplication", processVariables );
		//qualify with a bit higher interest rate, good credit, jumbo loan
		processVariables = getProcessArgs( "Max", "12307 Wilshire", 333224446, 200000, 1000000, 200000, 30 );
		kieSession.startProcess( "com.redhat.bpms.examples.mortgage.MortgageApplication", processVariables );
		//qualify with a bit higher interest rate, good credit, jumbo loan
		processVariables = getProcessArgs( "Marry", "12308 Wilshire", 333224446, 200000, 1000000, 200000, 30 );
		kieSession.startProcess( "com.redhat.bpms.examples.mortgage.MortgageApplication", processVariables );
		//interest rate too high, fails to qualify, terrible credit, jumbo loan
		processVariables = getProcessArgs( "Joe", "12309 Wilshire", 333224442, 200000, 1000000, 200000, 30 );
		kieSession.startProcess( "com.redhat.bpms.examples.mortgage.MortgageApplication", processVariables );
		//down payment too low, doesn't qualify, jumbo loan
		processVariables = getProcessArgs( "Jill", "12310 Wilshire", 333224442, 200000, 1000000, 200000, 30 );
		kieSession.startProcess( "com.redhat.bpms.examples.mortgage.MortgageApplication", processVariables );
		//down payment too low, doesn't qualify, jumbo loan
		processVariables = getProcessArgs( "Rachel", "12311 Wilshire", 333224446, 200000, 1000000, 100000, 30 );
		kieSession.startProcess( "com.redhat.bpms.examples.mortgage.MortgageApplication", processVariables );
		//down payment too low, doesn't qualify, jumbo loan
		processVariables = getProcessArgs( "Raphael", "12312 Wilshire", 333224446, 200000, 1000000, 100000, 30 );
		kieSession.startProcess( "com.redhat.bpms.examples.mortgage.MortgageApplication", processVariables );
		//incorrect ssn
		processVariables = getProcessArgs( "Jennifer", "12313 Wilshire", 33322444, 200000, 1000000, 100000, 30 );
		kieSession.startProcess( "com.redhat.bpms.examples.mortgage.MortgageApplication", processVariables );
		//incorrect ssn
		processVariables = getProcessArgs( "Jason", "12314 Wilshire", 33322444, 200000, 1000000, 100000, 30 );
		kieSession.startProcess( "com.redhat.bpms.examples.mortgage.MortgageApplication", processVariables );
		//amortization not offered
		processVariables = getProcessArgs( "Mike", "12315 Wilshire", 333224446, 200000, 1000000, 100000, 20 );
		kieSession.startProcess( "com.redhat.bpms.examples.mortgage.MortgageApplication", processVariables );
		//amortization not offered
		processVariables = getProcessArgs( "Molly", "12316 Wilshire", 333224446, 200000, 1000000, 100000, 20 );
		kieSession.startProcess( "com.redhat.bpms.examples.mortgage.MortgageApplication", processVariables );

		System.out.println();
		System.out.println("Process instances loaded succesfully, see log for details.");
		System.out.println();
	}

	private static RuntimeEngine getRuntimeEngine(String applicationContext, String deploymentId, String userId, String password)
	{
		try
		{
			URL jbpmURL = new URL( applicationContext );
			RemoteRestRuntimeEngineFactory remoteRestSessionFactory = RemoteRestRuntimeEngineFactory.newBuilder()
        .addDeploymentId(deploymentId)
        .addUrl(jbpmURL)
        .addUserName(userId)
        .addPassword(password)
        .buildFactory();
			RuntimeEngine runtimeEngine = remoteRestSessionFactory.newRuntimeEngine();
			return runtimeEngine;
		}
		catch( MalformedURLException e )
		{
			throw new IllegalStateException( "This URL is always expected to be valid!", e );
		}
	}

	private static Map<String, Object> getProcessArgs(String name, String address, int ssn, int income, int price, int downPayment, int amortization)
	{
		Map<String, Object> processVariables = new HashMap<String, Object>();
		Applicant applicant = new Applicant( name, ssn, income, null );
		Property property = new Property( address, price );
		Application application = new Application( applicant, property, null, downPayment, amortization, null, null, null );
		processVariables.put( "application", application );
		//Equivalent of http://localhost:8080/jbpm-console/rest/runtime/com.redhat.bpms.examples:mortgage:1/process/com.redhat.bpms.examples.mortgage.MortgageApplication/start?map_name=Babak&map_address=12300%20Wilshire&map_ssn=333224449i&map_income=200000i&map_price=1000000i&map_downPayment=200000i&map_amortization=30i
		return processVariables;
	}
}
