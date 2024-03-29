node{


	stage('checkout'){
	    checkout scm
	}
    def dockerimage
    dockerimage = docker.build('mybuilder')
	stage('build'){
       dockerimage.inside("-v $HOME:/var/maven -v $HOME/.sonar:/var/maven/.sonar -e MAVEN_CONFIG=/var/maven/.m2 -e _JAVA_OPTIONS=-Duser.home=/var/maven") {
        sh "mvn clean install -DskipTests=true"
    	}
	}

	stage('Clover'){
       dockerimage.inside("-v $HOME:/var/maven -v $HOME/.sonar:/var/maven/.sonar -e MAVEN_CONFIG=/var/maven/.m2 -e _JAVA_OPTIONS=-Duser.home=/var/maven") {
        sh "mvn clover:setup test clover:aggregate clover:clover"
    	}

	  step([
    $class: 'CloverPublisher',
    cloverReportDir: 'target/site',
    cloverReportFileName: 'clover.xml',
    healthyTarget: [methodCoverage: 70, conditionalCoverage: 80, statementCoverage: 80], // optional, default is: method=70, conditional=80, statement=80
    unhealthyTarget: [methodCoverage: 50, conditionalCoverage: 50, statementCoverage: 50], // optional, default is none
    failingTarget: [methodCoverage: 0, conditionalCoverage: 0, statementCoverage: 0]     // optional, default is none
  ])
  }

    stage('PMD'){
    	dockerimage.inside("-v $HOME:/var/maven -v $HOME/.sonar:/var/maven/.sonar -e MAVEN_CONFIG=/var/maven/.m2 -e _JAVA_OPTIONS=-Duser.home=/var/maven") {
    		sh "mvn pmd:pmd"
    	}
        pmd canComputeNew: false, defaultEncoding: '', healthy: '', pattern: '', unHealthy: ''
    }

	stage('DRY'){
    	dockerimage.inside("-v $HOME:/var/maven -v $HOME/.sonar:/var/maven/.sonar -e MAVEN_CONFIG=/var/maven/.m2 -e _JAVA_OPTIONS=-Duser.home=/var/maven") {
    		sh "mvn pmd:cpd"
    	}
        dry canComputeNew: false, defaultEncoding: '', healthy: '', pattern: '', unHealthy: ''
    }
    //stage 'JaCoCo'
    //    jacoco()

    //stage 'Cobertura'
    //    cobertura autoUpdateHealth: false, autoUpdateStability: false, coberturaReportFile: '**/target/site/cobertura/coverage.xml', conditionalCoverageTargets: '70, 0, 0', failUnhealthy: false, failUnstable: false, lineCoverageTargets: '80, 0, 0', maxNumberOfBuilds: 0, methodCoverageTargets: '80, 0, 0', onlyStable: false, sourceEncoding: 'ASCII', zoomCoverageChart: false

    stage('CheckStyle'){
        dockerimage.inside("-v $HOME:/var/maven -v $HOME/.sonar:/var/maven/.sonar -e MAVEN_CONFIG=/var/maven/.m2 -e _JAVA_OPTIONS=-Duser.home=/var/maven") {
	        sh "mvn checkstyle:checkstyle"
    	}
        checkstyle canComputeNew: false, defaultEncoding: '', healthy: '', pattern: '', unHealthy: ''
    }

	stage('findbugs'){
        dockerimage.inside("-v $HOME:/var/maven -v $HOME/.sonar:/var/maven/.sonar -e MAVEN_CONFIG=/var/maven/.m2 -e _JAVA_OPTIONS=-Duser.home=/var/maven") {
	        sh "mvn findbugs:findbugs"
    	}
	    findbugs canComputeNew: false, canRunOnFailed: true, defaultEncoding: '', excludePattern: '', healthy: '', includePattern: '', unHealthy: ''
	}
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
	stage('SonarQube'){
       dockerimage.inside("-v $HOME:/var/maven -v $HOME/.sonar:/var/maven/.sonar -e MAVEN_CONFIG=/var/maven/.m2 -e _JAVA_OPTIONS=-Duser.home=/var/maven") {
        sh "mvn sonar:sonar -Dsonar.host.url=http://172.17.0.1:9000"
    	}
	}

}
