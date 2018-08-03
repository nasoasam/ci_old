node{
    def dockerimage
    dockerimage = docker.build('mybuilder')

	stage('checkout'){
	    checkout scm
	}
	stage('build'){
       dockerimage.inside("-v $HOME/.m2:/var/maven/.m2 -e MAVEN_CONFIG=/var/maven/.m2 -e _JAVA_OPTIONS=-Duser.home=/var/maven") {
        sh "mvn install -DskipTests=true"
    	}
	}
    stage('test') {
		def splits = splitTests([$class: 'CountDrivenParallelism', size: 1])
	    def branches = [:]
	    def c = [:]

		stash includes: '**/*', name: 'files'
	    for(int i = 0; i < splits.size(); i++) {
            def exclusions = splits.get(i);
  	        int port=60000 + i
	        branches["split${i}"] = {
	            node {
		            sh 'rm -rf *'
	                unstash 'files'
	                parallel (
	                    spring : {
	                        dockerimage.inside("-p ${port}:8080 -v $HOME/.m2:/var/maven/.m2 -e MAVEN_CONFIG=/var/maven/.m2 -e _JAVA_OPTIONS=-Duser.home=/var/maven") {
	                            sh "mvn spring-boot:run -Dmaven.test.skip=true"
	                        }
	                    },
	                    selenium : {
	                        sh "wget --spider -nv --tries 0 --waitretry 1 --retry-connrefused 10.33.0.100:${port}"
	                        dockerimage.inside("-v $HOME/.m2:/var/maven/.m2 -e MAVEN_CONFIG=/var/maven/.m2 -e _JAVA_OPTIONS=-Duser.home=/var/maven") {
    	                        writeFile file: 'exclusions.txt', text: exclusions.join("\n")
	                            sh "mvn test -Dselenide.baseUrl=http://10.33.0.100:${port} -Dselenide.browser=ie -Dremote=http://10.33.0.232:4444/wd/hub"
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
