node{


	stage('checkout'){
	    checkout scm
	}
    def dockerimage
    dockerimage = docker.build('mybuilder')
	stage('build'){
       dockerimage.inside("-v $HOME/.m2:/var/maven/.m2 -v $HOME/.sonar:/var/maven/.sonar -e MAVEN_CONFIG=/var/maven/.m2 -e _JAVA_OPTIONS=-Duser.home=/var/maven") {
        sh "mvn clean install findbugs:findbugs -DskipTests=true"
        sh "mvn sonar:sonar -Dsonar.host.url=http://172.17.0.1:9000"
    	}
	}
	stage 'findbugs'
	    findbugs canComputeNew: false, canRunOnFailed: true, defaultEncoding: '', excludePattern: '', healthy: '', includePattern: '', unHealthy: ''

    stage 'stepCount'
    	stepcounter settings: [[encoding: 'UTF-8', filePattern: 'src/main/java/**/*.java', filePatternExclude: '', key: 'java']]

//    stage('test') {
//		def splits = splitTests([$class: 'CountDrivenParallelism', size: 1])
//	    def branches = [:]
//	    def c = [:]
//
//		stash includes: '**/*', name: 'files'
//	    for(int i = 0; i < splits.size(); i++) {
//            def exclusions = splits.get(i)
//		    def command = $/
//            (netstat --listening --all --tcp --numeric \
//            | sed '1,2d; s/[^[:space:]]*[[:space:]]*[^[:space:]]*[[:space:]]*[^[:space:]]*[[:space:]]*[^[:space:]]*:\([0-9]*\)[[:space:]]*.*/\1/g' \
//            | sort -n | uniq; seq 1 60000; seq 1 65535) \
//            | sort -n | uniq -u | shuf -n 1 | tr -d "\n"
//        /$
//        def port = sh returnStdout: true, script: command
//	        branches["split${i}"] = {
//	            node {
//		            sh 'rm -rf *'
//	                unstash 'files'
//	                parallel (
//	                    spring : {
//	                        dockerimage.inside("-p ${port}:8080 -v $HOME/.m2:/var/maven/.m2 -e MAVEN_CONFIG=/var/maven/.m2 -e _JAVA_OPTIONS=-Duser.home=/var/maven") {
//	                            sh "mvn spring-boot:run -Dmaven.test.skip=true"
//	                        }
//	                    },
//	                    selenium : {
//	                        sh "wget --spider -nv --tries 0 --waitretry 1 --retry-connrefused 10.33.0.100:${port}"
//	                        dockerimage.inside("-v $HOME/.m2:/var/maven/.m2 -e MAVEN_CONFIG=/var/maven/.m2 -e _JAVA_OPTIONS=-Duser.home=/var/maven") {
//    	                        writeFile file: 'exclusions.txt', text: exclusions.join("\n")
//	                            sh "mvn test -Dselenide.baseUrl=http://10.33.0.100:${port} -Dselenide.browser=chrome -Dremote=http://10.33.0.100:4444/wd/hub"
//	                            step([$class: 'JUnitResultArchiver', testResults: 'target/surefire-reports/*.xml'])
//	                        }
//	                        sh "curl -X POST 10.33.0.100:${port}/actuator/shutdown"
//	                    }
//	                )
//	            }
//	        }
//	    }
//	    parallel branches
////        mattermostSend color: 'good', message: 'ビルドが完了しました。', text: 'optional for here mentions and searchable text'
//step([$class: 'CheckStylePublisher', pattern: "checkstyle/*.xml"])
//step([$class: 'FindBugsPublisher', pattern: "findbugs/*.xml"])
//                            archiveArtifacts "checkstyle/*.xml"
//                            archiveArtifacts "findbugs/*.xml"
//    stage 'JaCoCo'
//    jacoco classPattern: '**/target/classes', execPattern: '**/target/**.exec'
//
//    stage 'CheckStyle'
//    checkstyle canComputeNew: false, defaultEncoding: '', healthy: '', pattern: 'target/site/checkstyle/checkstyle-result.xml', unHealthy: ''
//
//    stage 'findbugs'
//    findbugs canComputeNew: false, canRunOnFailed: true, defaultEncoding: '', excludePattern: '', healthy: '', includePattern: '', pattern: 'target/site/findbugs/findbugsXml.xml', unHealthy: ''
//
//    stage 'stepCount'
//    stepcounter settings: [[encoding: 'UTF-8', filePattern: 'src/main/java/**/*.java', filePatternExclude: '', key: 'java']]

//        mattermostSend color: 'good', message: 'ビルドが完了しました。'
//	}
}
