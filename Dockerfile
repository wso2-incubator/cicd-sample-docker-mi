# ------------------------------------------------------------------------
#
# Copyright 2020 WSO2, Inc. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License
#
# ------------------------------------------------------------------------
FROM maven:3.3.9-jdk-8 AS builder

# Cache maven dependencies
ENV MAVEN_OPTS="-Dmaven.repo.local=/root/m2repo/"
COPY helloworld/pom.xml /usr/src/mymaven/helloworld/
RUN mvn -f /usr/src/mymaven/helloworld/pom.xml dependency:go-offline -B

COPY helloworld /usr/src/mymaven/helloworld
COPY helloworldCompositeApplication /usr/src/mymaven/helloworldCompositeApplication
RUN mvn -f /usr/src/mymaven/helloworld/pom.xml clean install -Dmaven.test.skip=true
RUN mvn -f /usr/src/mymaven/helloworldCompositeApplication/pom.xml clean install -Dmaven.test.skip=true

FROM <BASE>
COPY --from=builder /usr/src/mymaven/helloworldCompositeApplication/target/helloworldCompositeApplication_1.0.0.car ${WSO2_SERVER_HOME}/repository/deployment/server/carbonapps
