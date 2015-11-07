package com.redhat.bpms.examples.mortgage;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StringWriter;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.ResponseHandler;
import org.apache.http.entity.ContentType;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.XMLWriter;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@SuppressWarnings("unchecked")
public class XmlResponseHandler<T,P> implements ResponseHandler<T> {

    protected static final Logger logger = LoggerFactory.getLogger(XmlResponseHandler.class);

    protected final Class<T> returnType;
    protected Class<P> parameterType = null;
    private int status = 200;

    private JAXBContext jaxbContext = null;
    private List<Class> extraJaxbClasses = new ArrayList<Class>(0);

    protected final ContentType myContentType;

    public XmlResponseHandler(ContentType type, int status, Class<T>... returnTypes) {
        this.myContentType = type;
        this.status = status;
        if( returnTypes != null && returnTypes.length > 0 ) {
            this.returnType = returnTypes[0];
            if( returnTypes.length == 2 ) {
                this.parameterType = (Class<P>) returnTypes[1];
            }
        } else {
            this.returnType = null;
        }
    }

    public XmlResponseHandler(ContentType type, Class<T>... returnTypes) {
        this.myContentType = type;
        if( returnTypes != null && returnTypes.length > 0 ) {
            this.returnType = returnTypes[0];
            if( returnTypes.length == 2 ) {
                this.parameterType = (Class<P>) returnTypes[1];
            }
        } else {
            this.returnType = null;
        }
    }

    public void addExtraJaxbClasses( Class... extraClass ) {
        this.extraJaxbClasses.addAll(Arrays.asList(extraClass));
    }

    public T handleResponse( HttpResponse response ) throws ClientProtocolException, IOException {
        int responseStatus = response.getStatusLine().getStatusCode();

        HttpEntity entity = response.getEntity();
        assertNotNull("Empty response content", entity);

        ContentType contentType = ContentType.getOrDefault(entity);
        Charset charset = contentType.getCharset();

        InputStream contentStream = entity.getContent();
        Reader reader;
        if( charset != null ) {
            reader = new InputStreamReader(contentStream, charset);
        } else {
            reader = new InputStreamReader(contentStream);
        }
        reader = new BufferedReader(reader);

        if( status != responseStatus ) {
            if( ! myContentType.equals(contentType) ) {
                if( contentType.toString().contains("text/html") ) {
                    StringWriter writer = new StringWriter();
                    char[] buffer = new char[1024];
                    for (int n; (n = reader.read(buffer)) != -1; ) {
                        writer.write(buffer, 0, n);
                    }
                    String content = writer.toString();
                    // now that we know that the result is wrong, try to identify the reason
                    Document doc = Jsoup.parse(content);
                    String errorBody = doc.body().text();
                    fail( responseStatus + ": " + errorBody + " [expected " + status + "]" );
                }  else {
                    assertEquals("Response status [content type: " + contentType.toString() + "]", status, responseStatus);
                }
            } else if( contentType.toString().contains("text/plain") ) {
                    StringWriter writer = new StringWriter();
                    char[] buffer = new char[1024];
                    for (int n; (n = reader.read(buffer)) != -1; ) {
                        writer.write(buffer, 0, n);
                    }
                    String errorBody = writer.toString();
                    // now that we know that the result is wrong, try to identify the reason
                    fail( responseStatus + ": " + errorBody + " [expected " + status + "]" );
            } else {
                assertEquals("Response status", status, responseStatus);
            }
        }

        char[] arr = new char[8 * 1024];
        StringBuilder buffer = new StringBuilder();
        int numCharsRead;
        while ((numCharsRead = reader.read(arr, 0, arr.length)) != -1) {
            buffer.append(arr, 0, numCharsRead);
        }
        reader.close();

        if( returnType != null ) {
            return deserialize(buffer.toString());
        } else {
            return null;
        }

    }
    
    protected T deserialize(String content) {

        if( logger.isTraceEnabled() ) {
            try {
                org.dom4j.Document doc = DocumentHelper.parseText(content);
                StringWriter sw = new StringWriter();
                OutputFormat format = OutputFormat.createPrettyPrint();
                XMLWriter xw = new XMLWriter(sw, format);
                xw.write(doc);
                String prettyContent = sw.toString();
                logger.trace("XML  < |\n{}", prettyContent );
            } catch( IOException ioe ) {
                logger.error( "Unabel to write XML document: " + ioe.getMessage(), ioe );
            } catch( DocumentException de ) {
                logger.error( "Unabel to parse text: " + de.getMessage(), de );
            }
        }

        JAXBContext jaxbContext = getJaxbContext();

        Unmarshaller unmarshaller = null;
        try {
            unmarshaller = jaxbContext.createUnmarshaller();
        } catch( JAXBException jaxbe ) {
            throw new IllegalStateException("Unable to create unmarshaller", jaxbe);
        }

        ByteArrayInputStream contentStream = new ByteArrayInputStream(content.getBytes());
        Object jaxbObj = null;
        try {
            jaxbObj = unmarshaller.unmarshal(contentStream);
        } catch( JAXBException jaxbe ) {
           throw new IllegalStateException("Unable to unmarshal reader", jaxbe);
        }

        Class returnedClass = jaxbObj.getClass();
        assertTrue( returnedClass.getSimpleName() + " received instead of " + this.returnType.getSimpleName(),
                returnType.isAssignableFrom(returnedClass) );
        return (T) jaxbObj;
    }

    private JAXBContext getJaxbContext() {
        if( jaxbContext == null ) {
            Set<Class> types = new HashSet<Class>(2);
            types.add(returnType);
            if( parameterType != null ) {
                types.add(this.parameterType);
            }
            if( ! extraJaxbClasses.isEmpty() ) {
               types.addAll(extraJaxbClasses);
            }

            try {
                jaxbContext = JAXBContext.newInstance(types.toArray(new Class[types.size()]));
            } catch( JAXBException jaxbe ) {
                throw new IllegalStateException("Unable to create JAXBContext", jaxbe);
            }
        }
        return jaxbContext;
    }

    public String serialize( Object entity ) {
        JAXBContext jaxbContext;
        List<Class> typeList = new ArrayList<Class>();
        typeList.add(entity.getClass());

        if( ! extraJaxbClasses.isEmpty() ) {
            typeList.addAll(extraJaxbClasses);
        }

        try {
            jaxbContext = JAXBContext.newInstance(typeList.toArray(new Class[typeList.size()]));
        } catch( JAXBException jaxbe ) {
            throw new IllegalStateException("Unable to create JAXBContext", jaxbe);
        }

        return serialize(entity, jaxbContext);
    }

    public String serialize( Object entity, JAXBContext jaxbContext ) {
        Marshaller marshaller = null;
        try {
            marshaller = jaxbContext.createMarshaller();
            if( logger.isTraceEnabled() ) {
                marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
            }
        } catch( JAXBException jaxbe ) {
            throw new IllegalStateException("Unable to create unmarshaller", jaxbe);
        }

        StringWriter xmlStrWriter = new StringWriter();
        try {
            marshaller.marshal(entity, xmlStrWriter);
        } catch( JAXBException jaxbe ) {
           throw new IllegalStateException("Unable to marshal " + entity.getClass().getSimpleName() + " instance", jaxbe);
        }

        String out = xmlStrWriter.toString();
        logger.trace("XML  > |\n{}", out );
        return out;
    }

}

