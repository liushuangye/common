package com.test;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
//import org.junit.Test;

public class TestMain {
	public static void main(String[] args){
		//1. 加载Hibernate的核心配置文件
		Configuration configuration = new Configuration().configure();
		//如果在Hibernate的核心配置文件没有设置加载哪个映射文件，则可手动加载映射文件
		//configuration.addResource("com/meimeixia/hibernate/demo01/Customer.hbm.xml");
		
		//2. 创建SessionFactory对象，类似于JDBC中的连接池
		SessionFactory sessionFactory = configuration.buildSessionFactory();
		
		//3. 通过SessionFactory获取到Session对象，类似于JDBC中的Connection
		Session session = sessionFactory.openSession();
		
		//4. 手动开启事务，（最好是手动开启事务）
		Transaction transaction = session.beginTransaction();
		
		//5. 编写代码
		/*
		Company company1 = new Company();
		company1.setName("公司3");
		
		Person person1 = new Person();
		person1.setName("张1");
		person1.setCompany(company1);
		Person person2 = new Person();
		person2.setName("张2");
		person2.setCompany(company1);
		
		company1.getPersons().add(person1);
		company1.getPersons().add(person2);
//		session.save(person1);//保存一个人
		session.save(company1);//保存一个公司
		*/
//		Company company = session.get(Company.class, 14);
//		session.delete(company);
		
		Person person = session.get(Person.class, 18);
		session.delete(person);
		
		//6. 事务提交
		transaction.commit();
		
		//7. 释放资源
		session.close();
		sessionFactory.close();
	}
	
}