# Hackerrank technical test for Picaio

1. Terraform Data Sources

Terraform data sources will be used to fetch the latest Amazon Linux AMI for the Amazon EC2 instance that will be created using Terraform. Which Terraform data source configuration should be used?

Pick ONE option

( ) data "aws_ami" "ami" {owners=["amazon"] latest=true filter{name="type" values=["amzn2-ami-hvm-20.200722.0-86*""]}}

( ) data "aws_ami" "ami" {owners=["amazon"] most_recent=true filter{name="type" values=["amzn2-ami-hvm-20.200722.0-86*""]}}

( ) data "aws_ami" "ami" {owners=["amazon"] latest=true filter{name="name" values=["amzn2-ami-hvm-20.200722.0-86*""]}}

`Answer:` 

(X) data "aws_ami" "ami" {owners=["amazon"] most_recent=true filter{name="name" values=["amzn2-ami-hvm-20.200722.0-86*""]}}

Why?
Because:
• aws_ami uses most_recent=true to get the most recent AMI.
• The correct filter is name, not type.
• owners = ["amazon"] limits the images to official Amazon images.
• The wildcard * allows you to find the latest available version.

Errors in the other options
• ❌ latest = true → this property does not exist in Terraform AWS Provider.
• ❌ filter { name = "type" ... } → type is not the correct attribute to search for AMIs by name/version.
• ❌ Without most_recent = true, it does not guarantee obtaining the latest image.

---

2. Init Process

A system administrator is working with a newly launched Linux distribution called XMars OS which utilizes an innovative init process.

Te init process is divided into two stages: Stage1 and Stage2.

During Stage1, the init process performs crucial system tasks such as hardware detection, device driver initialization, and system environment setup.

Once Stage1 is successfully completed, the system advances to Stage2, where the init process carries out advanced operations, including module loading, network configuration, and launching user sessions.

While addressing a critical issue, the system administrator suspects a problem with the init process. During analysis, it is discovered that during the boot process, the system successfully completes Stage1. However, the system fails to complete Stage2, and the init process seems to halt indefinitely.

What is the most likely cause?

( ) XMars OS uses a security feature that requieres manual authentication using credentials which was not provided by the administrator.

( ) An unexpected system call or error during the boot process causes the init process to halt indefinitely.

( ) A misconfigured firewall is blocking the communication between Stage1 and Stage2, preventing the init process from advancing to Stage2.

`Answer:`

(X) The system encounters a bug in the kernel during Stage1, resulting a deadlock situation that prevents the init process from proceeding to Stage2.

Why?
Because:

The statement clearly says that:
• Stage1 is partially completed, performing critical tasks:
    • hardware detection
    • device drivers
    • environment setup
• But the system:
    • does not advance to Stage2
    • the init process remains "halt indefinitely"

This points to a deadlock or blockage of the kernel/init process during the transition between stages.

Why the others are NOT:
• ❌ Manual authentication
    • It doesn't mention authentication or credentials.
• ❌ Unexpected system call
    • Too generic and less precise.
• ❌ Firewall between Stage1 and Stage2
    • It doesn't make technical sense: Stage1 and Stage2 are internal boot processes, not network communication.

The key here is to identify:

• boot sequence
• init process
• kernel deadlock
• hang during boot

---

3. Job Scheduling

In a Linux environment, an administrator needs to schedule a complex job that involves executing a series of commands every Sunday at 2:00 AM. The job has dependencies, requires elevated privileges for certain commands, and the output must be captured in a log file.

Which option is the most suitable approach?

The best answer is the first option (systemd timer unit) ✅

Because the scenario mentions:

• recurring execution (every Sunday at 2:00 AM)
• dependencies
• elevated privileges
• logging
• complex job

All of that fits better with systemd timers, which are more modern and robust than cron.

The `correct option` would be:

(X)
1. Create a systemd timer unit.
2. Configure the timer unit to run every Sunday at 2:00 AM.
3. Write a custom script containing the necessary commands and dependencies.
4. Ensure the custom script has appropriate permissions.
5. Direct the output of the custom script to a designated log file.

Why not the others?
• ❌ `at` command
    • `at` is for one-time execution, not recurring weekly.
• ⚠️ `cron`
    • It works, but for complex jobs with dependencies and advanced control, systemd timers are currently the best practice in modern Linux.
• ❌ `systemd target unit`
    • Target units are not for periodic scheduling.

Useful information for interviews:

Quick difference

Tool | Use
cron | for simple recurring tasks
at | for single future execution
systemd timer | for modern complex tasks with logging, dependencies, and advanced control

Real example:

</> INI
# /etc/systemd/system/backup.timer
[Timer]
OnCalendar=Sun 02:00:00
Persistent=true

and associated with a:

</> INI
# backup.service
[Service]
ExecStart=/opt/scripts/backup.sh

---

4. Infrastructure Protection

An organization network is under attack from advanced threats. It hosts a firewall, server. Virtual Private Network (VPN) and Domain Name Server (DNS). The organization is concerned about data breaches and service disruptions.

Organization's Network:

Firewall -> Inbound Internet Traffic -> Server
                                             |
                                             v
VPN Gateway ->    VPN Traffic    -> DNS Server

What single action will most effectively enhance the network security posture?

( ) Configure the firewall to restrict all inbound traffic except for essential services.

( ) Implement a network access control (NAC) solution to manage device access to the network.

`Answer:`

(X) Set up an Intrusion Prevention System (IPS) between the firewall and internal server to monitor and block malicious traffic.

( ) Deploy an additional DNS server for redundancy and load balancing.

The correct answer is the third option ✅

“Set up an Intrusion Prevention System (IPS) between the firewall and internal server to monitor and block malicious traffic.”

Why?
The scenario states:

• the network is under advanced threat
• concern about:
    • data breaches
    • service disruptions

A firewall alone filters basic traffic, but an IPS:

• inspects traffic in depth
• detects known attacks and malicious behavior
• blocks exploits in real time
• protects internal services

It is the most effective security enhancement among the options.

Why NOT the others?

• ⚠️ Restrict inbound traffic
    • Good practice, but a firewall already exists and is not sufficient against advanced threats.
• ⚠️ NAC
    • Controls device access, but does not stop active attacks between the network/firewall/servers.
• ❌ Additional DNS server
    • Improves availability and redundancy, not security against advanced threats.

Interview Key:

Technology | Function
Firewall | Allow/Block traffic
IDS | Detect attacks
IPS | Detect and block attacks
NAC | Control device access

---

5. Data Leakage

This network diagram shows a company's setup with a server, multiple workstations, a wireless access point and a firewall. The company experiences intermittent data leakage from the server coinciding with high wireless access point usage. No external intrusion was detected in the firewall logs.

               Server
Firewall -----------------> WAP               
            |    |    |
            v    v    v
           WS1  WS2  WS3

What is the most likely cause and what is the best solution?

( ) Upgrade the firewall to a more advanced model to detect and prevent sophisticated cyber attacks.

`Answer:`

(X) Investigate a potential misconfiguration in the wireless access point that may be allowing unauthorized access to the network.

( ) Implement a stricter access control policy on the server to limit which workstations can access sensitive data.

( ) Conduct a thorough malware scan on all workstations, suspecting that a compromised device could be transmitting data.

Why?
The key clues are:

• There is data leakage.
• It coincides with high wireless access point usage.
• No external intrusion appears in firewall logs.

This suggests that:

• The attacker is probably entering through the Wi-Fi network.
• The firewall isn't detecting anything because the access is occurring within the internal network.
• The most likely problem is:
    • A poor Wi-Fi configuration.
    • A weak WPA.
    • A compromised password.
    • An open network.
    • Incorrect segmentation.

Why NOT the others?

• ❌ Upgrade firewall. 
    • It wouldn't help much if access is already occurring internally via Wi-Fi.
• ⚠️ Stricter server ACL. 
    • It mitigates the impact, but doesn't address the root cause.
• ⚠️ Malware scan. 
    • Possible, but the question specifically connects the problem to wireless AP usage.

The key to this question is:

“No external intrusion detected in firewall logs.”

This usually points to:

• An insider threat.
• Lateral movement.
• Wi-Fi compromise.
• Internal access.

---

6. Docker BuildKit Enable

You have decided to use BuildKit functionality of Docker Engine to speed up the build process. How do you enable this?

(X) `using "DOCKER_BUILDKIT" environment variable`

(X) `through "docker config" option set`

( ) using specific frontend override instruction set in Dockerfile

(X) `modify Docker default configuration (usually "/etc/docker/daemon.json")`

The question is: How do you enable Docker BuildKit?

And it says “Pick ONE or MORE options”.

The correct answers are:

✅ using the "DOCKER_BUILDKIT" environment variable
✅ through the "docker config" option
✅ modify the Docker default configuration (usually "/etc/docker/daemon.json")

❌ using a specific frontend override instruction set in the Dockerfile
(This allows you to use BuildKit syntax/features, but not to enable it directly).

Real-world examples:

export DOCKER_BUILDKIT=1

or in daemon.json:

{
    "features": {
    "buildkit": true
    }
}

Mark:

• 1
• 2
• 4

---

7. Docker Context Change Owner

You are composing a build scenario using Dockerfile instructions where you are adding an existing config folder from the host. The config folder should be owned by the "www-data" user so it can be accessed inside the container. What is the correct way to achieve this?

( ) COPY config/ /config
    RUN chown -R www-data /config

`Answer:`

(X) COPY --chown=www-data config/ /config

( ) USER www-data COPY config/ /config

The correct one here is:

✅ COPY --chown=www-data config/ /config

This is the modern and recommended way in Docker to copy files/directories, assigning ownership directly during the COPY command.

The others:

⚠️ COPY config/ /config + RUN chown -R www-data /config
→ Works, but is less efficient because it creates additional layers.

❌ USER www-data COPY config/ /config
→ Incorrect syntax. Using USER doesn't change ownership.

Only select the second option.

---

8. Kubernetes Strategic Merge Patch

While optimizing an existing Kubernetes cluster, you need to perform an update "web-application" deployment with improved RollingUpdate Strategy using Strategic Merge Patch. What is the correct way to achieve this goal?

Yes. The correct one uses `kubectl patch` with `--type strategic` and valid JSON inside `-p`.

The correct structure should look like this:

`Answer:`

(X) kubectl patch deployment web-application --type strategic -p '{"spec":{"strategy":{"rollingUpdate":{"maxSurge":"20%","maxUnavailable":"20%"}}}}'

( ) kubectl patch deployment web-application --type strategic -p $'spec:\n  strategy:\n    rollingUpdate:\n      maxSurge: 20%\n      maxUnavailable: 20%'

( ) kubectl patch deployment web-application -p $'spec:\n  strategy:\n    rollingUpdate:\n      maxSurge: 20%\n      maxUnavailable: 20%'

( ) kubectl patch deployment web-application -p '{"spec":{"strategy":{"rollingUpdate":{"maxSurge":"20%","maxUnavailable":"20%"}}}}'

The key point of the exam is:

• --type strategic ✅
• Well-formed JSON ✅
• spec.strategy.rollingUpdate.maxSurge and maxUnavailable within the patch ✅

The options with:

• Poorly escaped YAML ❌
• No --type strategic ❌
• Invalid JSON ❌
• Incorrect structure ❌

are incorrect.

Additionally, in Kubernetes, the following would typically be missing:

"type":"RollingUpdate"

leaving something more realistic:

kubectl patch deployment web-application --type strategic -p '{"spec":{"strategy":{"type":"RollingUpdate","rollingUpdate":{"maxSurge":"20%","maxUnavailable":"20%"}}}}'

HackerRank likely wants to validate:

• Strategic Merge Patch
• Correct JSON syntax
• Use of kubectl patch on Deployment.

---

9. Kubernetes Taint Remove

While working on a Kubernetes cluster, you found a taint was created on one of the nodes, No pod is able to schedule onto that node unless it has matching toleration. For debugging purposes, you have decided to remove the taint placed on the node "primary" matched for the "role=frontend". How will you do that?

( ) kubectl taint nodes primary role=frontend:NoSchedule

( ) kubectl taint nodes primary mode=remove role=frontend:NoSchedule

( ) kubectl taint nodes primary --rm role=frontend:NoSchedule

`Answer:`

(X) kubectl taint nodes primary role=frontend:NoSchedule-

The trailing hyphen (-) means REMOVE taint.

Important rule for Kubernetes:

• Add taint:
`kubectl taint nodes node1 key=value:NoSchedule`

• Remove taint:
`kubectl taint nodes node1 key=value:NoSchedule-`

In your exam:

• `node = primary`
• `taint = role=frontend:NoSchedule`

Therefore, it should look like this:

`kubectl taint nodes primary role=frontend:NoSchedule-`

The other options are invalid because:

• they don't have the trailing hyphen (-) ❌
• they use non-existent flags like `mode=remove` ❌
• they use `--rm`, which doesn't exist ❌

---

10. Kubeconfig: User Entry Set

There is an existing Kubernetes namespace "hacker-company".

Complete the file stub "/home/ubuntu/1162090-kubernetes-kubeconfig-user-entry-set/script.sh" with one or more steps that do the following:

    • creates a new user entry "replicator-manual" for the username "manual" and password "c00lp@SSW0rd"

    • updates an existing user entry "replicator-automated" to a token value access to the value of existing environment variable "$TOKEN"

Note:

    • The completed solution will be evaluated in a new, clean environment. ANY CHANGES MADE MANUALLY WILL BE LOST. ONLY CHANGES TO THE "script.sh" FILE IN "/home/ubuntu/1162090-kubernetes-kubeconfig-user-entry-set" WILL BE CARRIED TO THE NEW ENVIRONMENT.

    • The result of "sudo solve", invoked from the question directory, should solve the task.

    • You have sudo privileges, if needed.

You need to edit script.sh with something like this:

cd ~/1162090-kubernetes-kubeconfig-user-entry-set/

vim script.sh

i

#!/bin/bash

# Create new kubeconfig user
kubectl config set-credentials replicator-manual \
--username=manual \
--password='cO0lp@$$w0rd'

# Update existing user token
kubectl config set-credentials replicator-auto \
--token="$TOKEN"

esc -> :wq -> enter

Then:

chmod +x script.sh
sudo solve

The important part of the challenge:

Create a kubeconfig user:

kubectl config set-credentials USER \
--username=USERNAME \
--password=PASSWORD

Update the token:

kubectl config set-credentials USER \
--token="$TOKEN"

Exact details of your exercise:

• new user entry: replicator-manual
• username: manual
• password: cO0lp@$$w0rd
• existing user: replicator-auto
• token: $TOKEN

---

11. MDM Tools and Technologies

The shift towards remote or hybrid work has raised significant security concerns for enterprises. The core issue is that employees now access corporate data from locations outside the office using their personal devices. External networks, especially public Wi-Fi networks, are vulnerable to cyberattacks. Personal devices often lack essential security settings, weakening the security posture.

How can Master Data Management Tools assist in addressing these challenges?

( ) MDM tools can encrypt public Wi-Fi networks to make them more secure.

`Answer:`

(X) MDM tools can enforce security policies on personal devices used for work.

( ) MDM tools can physically secure remote workplaces to prevent cyber intrusions.

( ) MDM tools can create isolated personal and professional device profiles for users.

The correct answer is the second one ✅

“MDM tools can enforce security policies on personal devices used for work.”

MDM = Mobile Device Management.

What MDM actually does:

• apply security policies
• require device encryption
• enforce PIN/password
• control corporate access
• perform remote wipes
• perform compliance checks
• separate corporate data

The others are incorrect because:

• MDM does not encrypt public Wi-Fi networks ❌
• it does not “physically secure” remote offices ❌
• creating isolated profiles can occur in some MDM/UEM systems, but it doesn't address the main problem in this scenario ❌

Therefore, mark:

✅ MDM tools can enforce security policies on personal devices used for work.

---

12. Cookie Flags

As a second layer of defense against XSS attacks, which of the following attribute of cookies can be used to prevent a malicious attacker from reading an authenticated user's cookie through JavaScript?

( ) SameSite=Strict
(X) HttpOnly
( ) Secure
( ) Expires

`Answer:` HttpOnly

Why?
The question specifically asks which attribute prevents an attacker from reading the cookie using JavaScript (XSS).

Flag | What does it protect? 

• HttpOnly ✅ | Blocks access to the cookie from document.cookie in JS — exactly what the question describes. 
• SameSite=Strict | Protects against CSRF, not reading by JS. 
• Secure | Only sends the cookie over HTTPS, does not block JS. 
• Expires | Defines when the cookie expires, unrelated to XSS security.

Quick explanation

When an attacker injects malicious JS (XSS), they try to steal the session cookie with:

document.cookie // ← HttpOnly completely blocks this.

With HttpOnly, the browser denies any access to that cookie from JavaScript, even if the attacker has managed to execute code on the page.

---

13. Artifact Anomaly

In an optimized setup, a data architect observes inconsistent analytics job performance. The architecture includes a Databricks on AWS Delta table on Amazon S3, rapid cluster provisioning through instance pools and Delta cache enabled on high-memory instances. Performance dips mainly occur during Delta cache population, unrelated to AWS throttling or instance reclamation. 

What part of the Databricks configuration could be causing this?

`Answer:`

(X) When rapidly provisioning new instances, the instance pools might sometimes introduce nodes with cold starts, causing an initial I/O performance dip during Delta cache population.

( ) Databricks internal mechanism for Delta cache population sometimes leads to cache fragmentation causing suboptimal cache utilization during its initial fills.

( ) The Delta cache while designed to expedite reads, has an undocumented behavior where first-time population from specific partitions exhibits throttling to avoid overwhelming the underlying instance.

( ) The high-memory instances, though optimized for caching, periodically synchronize with Databricks control plane, introducing sporadic latency during intense I/O operations.

Why?

The scenario has key clues:

Clue in the statement: | What it means: 

Uses instance pools. | VMs are pre-warmed, but the local Delta cache (SSD) is empty. 
Dips during Delta cache population. | The first read goes directly to S3 → slower. 
Not related to AWS throttling or reclamation. | Rules out options 3 and 4.

The technical logic:

Instance pools keep VMs warm, but the Delta cache resides on the instance's local disk. When a new node is provisioned from the pool:

First read → S3 (slow) → written to the local Delta cache.
Subsequent reads → local Delta cache (fast).

This initial cache fill period (cold start cache) is exactly the performance dip described.

Why rule out the others:

• Option 2: "Cache fragmentation" is not a documented behavior of Databricks.
• Option 3: It mentions throttling → the statement explicitly rules it out.
• Option 4: Synchronization with the control plane does not explain dips during cache population specifically.

---

14. Capturing Network Traffic Logs

A company will host their development applications on Amazon EC2 instances in AWS as shown in the architecture diagram. The application stack includes an Application Load Balancer (ALB) in the public subnet, a fleet of Amazon EC2 instances in an auto-scaling group in the public subnet, a fleet of Amazon EC2 instances that host the application logic, the APIs, and Amazon RDS for MySQL is hosted in the public subnet. Users can connect to the application from the internet. The application servers and databases must be secure.

Due to the criticality of the application the CTO for the organization is interested in seeing the network traffic logs between the interfaces of the Amazon EC2 instances and the database in the private subnets. How is this accomplished?

( ) Enable and configure AWS Security hub to capture information about the IP traffic going to and from network interfaces in the Amazon VPC.

( ) Enable and configure Amazon CloudWatch to capture information about the traffic going to and from network interfaces in the Amazon VPC.

`Answer:`

(X) Create a flow log to capture information about the IP traffic going to and from network interfaces in the Amazon VPC.

( ) Enable AWS CloudTrail to capture information about the IP traffic going to and from network interfaces in the Amazon VPC.

Why VPC Flow Logs?

The CTO wants to see the network traffic between the EC2 instances and the RDS database on the private subnet. That's exactly what VPC Flow Logs is for.

Why rule out the others:

Option | Service | Why NOT? 

1 ❌ | Security Hub | Aggregates security findings, does not capture network traffic 
2 ❌ | CloudWatch | Can receive flow logs, but does not capture them on its own 
3 ✅ | VPC Flow Logs | Designed exactly for this: IP traffic in/out of ENIs 
4 ❌ | CloudTrail | Logs AWS API calls, not network traffic

How VPC Flow Logs works

EC2 ←→ RDS (traffic in private subnet)
         ↓
VPC Flow Log captures:
- Source/Destination IP
- Ports, Protocol
- Bytes transferred
- ACCEPT / REJECT
         ↓
Sent to CloudWatch Logs or S3

Can be applied at the VPC, subnet, or specific ENI level — ideal for monitoring just the EC2 ↔ RDS communication mentioned in the statement.

---

15. AWS Security: Multi-Tiered System

A developer in designing a multi-tiered system that utilizes various AWS resources. The application will be hosted in Amazon Elastic Beanstalk, which uses an Amazon RDS database and an Amazon S3 bucket configured to use Server-Side Encryption with Customer-Provided Encryption Keys (SSE-C). In this configuration, Amazon S3 does not store the encryption key you provide but instead, stores a randomly salted hash-based message authentication code (HMAC) value of the encryption key in order to validate future requests.

Which of the following is a valid consideration that the developer should keep in mind when implementing this architecture?

( ) The salted HMAC value can be used to derive the value of the encryption key.

( ) The salted HMAC value can be used to decrypt the contents of the encrypted object.

`Answer:`

(X) If the encryption key is lost, the object is lost.

( ) If the encryption key is lost, the salted HMAC value can be used to decrypt the object.

Why?

With SSE-C (Server-Side Encryption with Customer-Provided Keys), AWS has a very specific behavior:

What AWS S3 does | What AWS S3 does NOT do 

Encrypts/decrypts the object | Does NOT save your key 
Saves the HMAC of the key | Cannot recover the key 
Validates that the key is correct in future requests |

Why discard the others:

Option | Why is it wrong? 

1 | The HMAC is a one-way function (hash) — impossible to derive the original key 
2 | The HMAC cannot decrypt anything, it only validates that the key is correct 
3 ✅ | Correct — without the key, the object is unrecoverable 
4 | The HMAC cannot decrypt the object under any circumstances

Key conclusion

SSE-C = YOU are 100% responsible for saving the key

Lost key → Permanently lost object
HMAC ≠ recovery key

This is the critical consideration that the developer must keep in mind when using SSE-C in production.

---

16. Google Cloud Cost Management

A multinational corporation is running a diverse set of workloads on the Google Cloud Platform (GCP), including data processing, machine learning and web applications. The corporation wants to optimize its cloud costs by efficiently utilizing resources, identifying idle or underutilized services, and implementing cost-saving measures across its GCP projects.

Which Google Cloud cost management practice or tool should the corporation consider implementing to achieve efficient resource utilization and cost savings for its diverse workloads?

( ) Utilize Google Cloud's "Sustained Use" pricing model for long-running instances.

( ) Implement Google Cloud Operations Suite for real-time performance monitoring and anomaly detection.

( ) Utilize Google Cloud's "Pay-as-you-go" pricing model for flexible resource allocation.

`Answer:`

(X) Set up Google Cloud's "Rightsizing Recommendations" to resize virtual machine instances based on historical usage.

Why?

The statement asks for exactly 3 things:

Statement Objective | What solves it? 

Use resources efficiently | ✅ Rightsizing adjusts VMs to the correct size 
Identify idle or underutilized services | ✅ Analyzes CPU/memory history 
Implement cost-saving measures | ✅ Recommends cheaper machine types

Why discard the others:

Option | Why NOT? 
1 - Sustained Use | Automatic discount for long-lived VMs, does not identify idle resources 
2 - Cloud Operations Suite | It is for monitoring and observability, not a cost management tool 
3 - Pay-as-you-go | It is GCP's default billing model, does not optimize utilization 
4 ✅ | Designed specifically to detect oversized VMs and reduce costs

How Rightsizing Recommendations works:

GCP analyzes the last 8 days of metrics
         ↓
Detects VMs with underutilized CPU/RAM
         ↓
Recommends switching to a smaller machine type
         ↓
Cost savings direct and actionable

It is the tool most directly aligned with the objective of the statement.

---

17. Google Kubernetes Engine (GKE) Architecture

A software company is in the process of migrating its application to Google Kubernetes Engine (GKE) on the Google Cloud Platform. The objective is to establish an event-driven architecture capable of managing a diverse array of events, encompassing user actions, system alerts, and data updates.

To guarantee elevated availability and fault tolerance within an event-driven architecture on Google Kubernetes Engine (GKE), which of the following approaches would be recommended?

`Answer:`

(X) Deploy applications across multiple GKE clusters in different regions, utilizing a global load balancer to distribute traffic. Use Pub/Sub for inter-cluster event communication.

( ) Use Kubernetes Jobs with Horizontal Pod Autoscaling to process events at scheduled intervals, ensuring efficient resource utilization.

( ) Implement Kubernetes StatefulSets for stateful event processing and maintain data consistency using Persistent Volumes.

( ) Use Kubernetes Deployments with Horizontal Pod Autoscaling for event-driven workload elasticity, and configure a custom metric for autoscaling based on the number of incoming events.

( ) Utilize Kubernetes Jobs with Horizontal Pod Autoscaling to process streaming events in a batch manner at scheduled intervals.

Why?

The question has two key requirements:

Requirement | Which option meets it? 

Event-driven architecture | Pub/Sub is GCP's native service for this 
High availability + fault tolerance | Multi-region clusters + global load balancer

Why rule out the others:

Option | Problem 
2 | Scheduled interval jobs ≠ real event-driven 
3 | StatefulSets are for stateful apps (databases), not for event-driven 
4 | HPA with custom metrics is good for elasticity, but doesn't address multi-region HA 
5 | Interval batching = scheduled processing, not event-driven

Architecture that describes Option 1

Usuarios/Eventos
      ↓
Global Load Balancer (GCP)
   ↙           ↘
GKE Cluster    GKE Cluster
(us-central)   (europe-west)
      ↕ Pub/Sub (inter-cluster events) ↕

• If one region fails → the other cluster continues operating (fault (tolerance)
• Pub/Sub handles asynchronous events between clusters (user actions, system alerts, data updates)
• The global load balancer ensures high availability and intelligent routing

---

18. Sum of Arrays

Given two arrays each of length n, arr1 and arr2 in one operation, any two elements of an array can be swapped. This can occur any number of times.

Find the maximum possible sum of i*(arr2[i] - arr1[i]) for all l ≤ i ≤ n after rearranging the arrays. ... ..

Solution in Python 3

Key logic
The sum to maximize is:

Σ i*(arr2[i] - arr1[i]) = Σ i*arr2[i] - Σ i*arr1[i]

To maximize it:

• arr2: sort in ascending order → large values ​​at large indices (maximizes i*arr2[i])
• arr1: sort in descending order → large values ​​at small indices (minimizes i*arr1[i])

Verification with the example:

arr1 desc: [4,3,2,1]   arr2 asc: [2,2,3,3]
i=1: 1*(2-4) = -2
i=2: 2*(2-3) = -2
i=3: 3*(3-2) =  3
i=4: 4*(3-1) =  8  → Total = 7 ✅

Code:

def getMaxSumOfArray(arr1, arr2):
    MOD = 10**9 + 7
    n = len(arr1)
    
    arr1.sort(reverse=True)  # Descendente → minimiza i*arr1[i]
    arr2.sort()              # Ascendente  → maximiza i*arr2[i]
    
    result = 0
    for i in range(1, n + 1):
        result += i * (arr2[i-1] - arr1[i-1])
    
    return result % MOD

Verified Sample Case:

arr1=[3,2,1], arr2=[10,10,10]
i=1: 1*(10-3) =  7
i=2: 2*(10-2) = 16
i=3: 3*(10-1) = 27  → Total = 50 ✅

Complejidad: O(n log n) — eficiente para n ≤ 10⁵.

---

19. Python: Digital to Analog Conversion and Scaling

Implement a digital to analog converter (DAC) that converts digital data into analog form. ... ..

Python 3 Solution

Algorithm Steps:

1. Parse each string → binary_input, scale_min, scale_max
2. Convert binary to decimal using int(binary, 2)
3. Apply the formula
4. Round to 1 decimal place

Quick Verification:

"00000001 0 200" → (1/255)*(200-0)+0 = 0.8  ✅
"00000010 0 50"  → (2/255)*(50-0)+0  = 0.4  ✅
"01111111 0 100" → (127/255)*(100)+0 = 49.8 ✅
"11111111 100 200" → (255/255)*(100)+100 = 200.0 ✅

Code:

def convertToAnalog(toParse):
    result = []
    
    for s in toParse:
        parts = s.split()
        binary_input = parts[0]
        scale_min = int(parts[1])
        scale_max = int(parts[2])
        
        # 1. Binario → decimal
        binary_value = int(binary_input, 2)
        
        # 2. Aplicar fórmula DAC
        analog_output = (binary_value / 255) * (scale_max - scale_min) + scale_min
        
        # 3. Redondear a 1 decimal
        result.append(round(analog_output, 1))
    
    return result

Key to the problem:

• `int(binary_input, 2)` → converts binary strings to decimal in Python natively.
• The formula is straightforward; there are no difficult edge cases.
• `round(x, 1)` handles rounding correctly.