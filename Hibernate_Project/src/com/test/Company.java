package com.test;

import java.util.HashSet;
import java.util.Set;

public class Company {
	private int id;
	private String name;
	private Set<Person> persons = new HashSet<Person>();
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Set<Person> getPersons() {
		return persons;
	}
	public void setPersons(Set<Person> persons) {
		persons = persons;
	}
	
}
