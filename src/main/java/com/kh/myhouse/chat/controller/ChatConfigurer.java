package com.kh.myhouse.chat.controller;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.AbstractWebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

@Configuration
@EnableWebSocketMessageBroker
public class ChatConfigurer extends AbstractWebSocketMessageBrokerConfigurer{
	

	@Override
	public void registerStompEndpoints(StompEndpointRegistry registry) {
		registry.addEndpoint("/stomp")
				.withSockJS()
				.setInterceptors(new HttpSessionHandshakeInterceptor());
		
	}

	@Override
	public void configureMessageBroker(MessageBrokerRegistry registry) {
		//핸들러메소드의 @SendTo 에 대응함. 여기서 등록된 url을 subscribe하는 client에게 전송.
		registry.enableSimpleBroker( "/chat","/hello","/lastCheck");
		
		//prefix로 contextPath를 달고 @Controller의 핸들러메소드@MessageMapping 를 찾는다.
		registry.setApplicationDestinationPrefixes("/myhouse");//contextPath
	}
	
}
