maid-mayuyu : jenkins visualizer
===========

use full color rgb led light to show latest jenkins build status.

* add a file called .jenkins.yaml, add source: http://your-path-to-jenkins-job-build-xml
* write jenkins-led.pde sketch to your arduino
 * LED Light (display latest build status): defaultly using pin #9 for G, #10 for B, #11 for R
 * LED Bar (display 10 latest builds status) : using pin #{18, 13, 12, 11, 10, 9, 8, 7, 6, 5} for nodes, using pin #{14, 16, 15} for RGB control
* run write-jenkins-status-serial.rb when build starts and ends
 * you may like to mod serial port settings
