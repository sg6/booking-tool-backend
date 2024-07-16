package com.sg6.springboot;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.CrossOrigin;

import java.text.NumberFormat;
import java.util.Random;


@RestController
public class HelloController {

	@CrossOrigin(origins = "http://localhost:4200")
	@GetMapping("/")
	public String index() {
		double randomNumber = Math.random() * 49 + 1;
		String randomStr = String.format("%.2f", randomNumber);
		return "<h1>Hello Leon</h1> <p>Greetings from Spring Boot! " + randomStr + "</p>";
	}

	@GetMapping("/random")
	public String randomIndex() {
		double randomNumber = Math.random() * 49 + 1;
		String randomStr = String.format("%.6f", randomNumber);
		return "<h1>Hello Random</h1> <p>Even more random numbers: " + randomStr + "</p>";
	}

}
