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
            def exclusions = splits.get(i)
            sh """
               (netstat --listening --all --tcp --numeric |
    sed '1,2d; s/[^[:space:]]*[[:space:]]*[^[:space:]]*[[:space:]]*[^[:space:]]*[[:space:]]*[^[:space:]]*:\([0-9]*\)[[:space:]]*.*/\1/g' |
    sort -n | uniq; seq 1 60000; seq 1 65535
    ) | sort -n | uniq -u | shuf -n 1
    """

  	        int port=$?
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
//        mattermostSend color: 'good', message: 'ビルドが完了しました。', text: 'optional for here mentions and searchable text'
        mattermostSend color: 'good', message: 'ビルドが完了しました。'
	}
}
