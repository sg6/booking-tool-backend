package com.example.springboot;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.CrossOrigin;
import java.util.Random;


@RestController
public class HelloController {

	@CrossOrigin(origins = "http://localhost:4200")
	@GetMapping("/")
	public String index() {
		double random = Math.random() * 49 + 1;
		return "Greetings from Spring Boot! " + random;
	}

}
