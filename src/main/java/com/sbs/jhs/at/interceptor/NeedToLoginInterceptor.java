package com.sbs.jhs.at.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component("needToLoginInterceptor") // 컴포넌트 이름 설정
public class NeedToLoginInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		
		
		
		System.out.println("needToLoginInterceptor 실행됨!");

		return HandlerInterceptor.super.preHandle(request, response, handler);
	}
}