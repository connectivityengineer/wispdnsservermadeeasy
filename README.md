Here is a script that will, on an Ubuntu 22.04 (and others) automagically install a DNS Server for you as well as change the SSH port to one of your choosing Certainly! Here's a brief overview of what the provided script does:

1. Package Installation: The script starts by updating the package repositories and then installing the bind9 (a popular DNS server software) and ufw (Uncomplicated Firewall) packages, if they are not already installed.

2. Firewall Initialization: It then enables ufw to ensure that any rules added are enforced.

3. Predefined IP Ranges: The script has a set of predefined internal IP address ranges that are automatically included to allow DNS queries:

    - 10.0.0.0/8

    - 172.16.0.0/12

    - 192.168.0.0/16

    - 100.64.0.0/10

    - The server's own subnet (automatically detected).

4. User Notification: It notifies the user about these predefined ranges and then provides an option to add additional IP ranges for DNS query permissions. The user can continue to add as many ranges as they like and conclude by entering done.

5. Bind9 Configuration: The script configures the bind9 service to use the root hints for DNS resolution (i.e., it will not rely on any upstream DNS servers). This is achieved by modifying the /etc/bind/named.conf.options file.

6. SSH Port Modification: The script prompts the user to specify a custom SSH port. Once provided, it modifies the sshd_config file to update the SSH port and then restarts the SSH service.

7. Firewall Adjustments: The script ensures that the firewall (`ufw`) allows incoming connections on the newly specified SSH port, as well as the default DNS port (53) from the predefined and user-specified IP ranges.

8. Final Notification: After completing all the tasks, the script informs the user of the new SSH port to use when connecting.

In essence, this script sets up a DNS server tailored to specific IP ranges, modifies the SSH port for security reasons, and configures the firewall to accommodate these changes.


