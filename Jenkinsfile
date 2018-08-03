node{
    stage('test') {
		def splits = splitTests([$class: 'CountDrivenParallelism', size: 1])
	    def branches = [:]
	    def c = [:]
	    def dockerimage
	    checkout scm
	    dockerimage = docker.build('mybuilder')
		stash includes: '**/*', name: 'files'
	    for(int i = 0; i < splits.size(); i++) {
            def exclusions = splits.get(i);
  	        int port=60000 + i
	        branches["split${i}"] = {
	            node {
	                unstash 'files'
	                parallel (
	                    spring : {
	                        dockerimage.inside("-u root:root -v $HOME/.m2:/root/.m2 -p ${port}:8080") {
	                            sh "mvn spring-boot:run -Dmaven.test.skip=true"
	                        }
	                    },
	                    selenium : {
	                        sh "wget --spider -nv --tries 0 --waitretry 1 --retry-connrefused 10.33.0.100:${port}"
	                        dockerimage.inside("-u root:root -v $HOME/.m2:/root/.m2") {
    	                        writeFile file: 'exclusions.txt', text: exclusions.join("\n")
	                            sh "mvn test -Dselenide.baseUrl=http://10.33.0.100:${port} -Dselenide.browser=chrome -Dremote=http://10.33.0.100:4444/wd/hub"
	                            step([$class: 'JUnitResultArchiver', testResults: 'target/surefire-reports/*.xml'])
	                        }
	                        sh "curl -X POST 10.33.0.100:${port}/actuator/shutdown"
	                    }
	                )
	            }
	        }
	    }
	    parallel branches
	}
}
