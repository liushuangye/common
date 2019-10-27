package com.test;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
//import org.junit.Test;

public class TestMain {
	public static void main(String[] args){
		//1. ����Hibernate�ĺ��������ļ�
		Configuration configuration = new Configuration().configure();
		//�����Hibernate�ĺ��������ļ�û�����ü����ĸ�ӳ���ļ�������ֶ�����ӳ���ļ�
		//configuration.addResource("com/meimeixia/hibernate/demo01/Customer.hbm.xml");
		
		//2. ����SessionFactory����������JDBC�е����ӳ�
		SessionFactory sessionFactory = configuration.buildSessionFactory();
		
		//3. ͨ��SessionFactory��ȡ��Session����������JDBC�е�Connection
		Session session = sessionFactory.openSession();
		
		//4. �ֶ��������񣬣�������ֶ���������
		Transaction transaction = session.beginTransaction();
		
		//5. ��д����
		/*
		Company company1 = new Company();
		company1.setName("��˾3");
		
		Person person1 = new Person();
		person1.setName("��1");
		person1.setCompany(company1);
		Person person2 = new Person();
		person2.setName("��2");
		person2.setCompany(company1);
		
		company1.getPersons().add(person1);
		company1.getPersons().add(person2);
//		session.save(person1);//����һ����
		session.save(company1);//����һ����˾
		*/
//		Company company = session.get(Company.class, 14);
//		session.delete(company);
		
		Person person = session.get(Person.class, 18);
		session.delete(person);
		
		//6. �����ύ
		transaction.commit();
		
		//7. �ͷ���Դ
		session.close();
		sessionFactory.close();
	}
	
}