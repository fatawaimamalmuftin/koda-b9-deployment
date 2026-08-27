1. init setup: 
group: sudo groupadd <name group>
user: sudo useradd -m <name user>
at srv:sudo mkdir <project name>
add user to group: sudo usermod -aG <group name> <user name>

2. make koda as owner and devteam the group
sudo chmod  <name owner>:<name group>

3. restricting acc
sudo chmod 750 <path file>

4. cd <change dir>, mkdir <make dir>, touch <make file>, cd .. <back dir 1 step>

5. chmod 770 app.sh

6. chmod 700 input.txt

7. chmod -R g=rwx src

8. chmod -R koda:devteam srv/project

9. chmod -R o-rwx /src/projectX

10. add koda to sudo group: sudo usermod -aG wheel koda
sudo chmod 750 README.md

11. sudo chown -R dako:devteam /srv/projectX
