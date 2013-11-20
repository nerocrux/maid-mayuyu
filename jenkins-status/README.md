maid-mayuyu : jenkins visualizer
===========

use full color rgb led light to show latest jenkins build status.

* add a file called .jenkins.yaml, add source: http://your-path-to-jenkins-job-build-xml
* write jenkins-led.pde sketch to your arduino
 * defaultly using pin #9 for G, #10 for B, #11 for R
* run write-jenkins-status-serial.rb when build starts and ends
 * you may like to mod serial port settings
