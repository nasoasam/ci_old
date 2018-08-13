package jp.dip.masao.ci;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

@RunWith(SpringRunner.class)
@SpringBootTest
public class CiApplicationDummy {

	@Test
	public void contextLoads() {
		System.out.println("a");
		CiApplication.main(null);
	}

}
