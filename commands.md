### Generate build script

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Clear App Cache & Everything

```
dart pub cache clean -f;flutter pub cache clean -f; flutter clean;flutter pub get
```

### Build for the web

```
flutter build web --web-renderer canvaskit
```

### Common fix for pod/cocoapod error on iOS

- run the following commands, follow the sequence

  ```bash

      # get into the ios folder
      cd ios/

      # clear all outdated pods
      sudo rm -r Pods
      #
      rm -f Podfile.lock

      # clean and reinstall
      pod install --repo-update --verbose ## use --verbose flag to track the changes, bacause this install can take up to 15mins since 'MobileVLCKit' is very big.

      # clean and reinstall (this command is not neccesary run this only if the one above failed/didn't work)
      pod cache clean --all;pod deintegrate --verbose;pod setup --verbose;pod install --verbose

      # DONE
      cd ../;flutter run
  ```

  ## firebase local server

  - `firebase emulators:start`

  ## ngrok

  - `ngrok start --config "~/Library/Application Support/ngrok/ngrok.yml" --all`

  ### push with a tag/ref

  - ```bash
    <!-- set remote configs -->
    gh variable set CONFIG_FILE < "lib/app_config.dart"
    <!-- push to git with a tag -->
    git add .
    git commit -m "Add two pages/tutorials, remove unused pkgs, version bump: v1.1.40.beta"
    git tag -a v1.1.40.beta -m "Add two pages/tutorials, version bump: v1.1.40.beta"
    git push origin v1.1.40.beta
    git push --follow-tags

    ```

### prepare secrets for git

- ```

  base64 -i android/key.properties -o android/key.base64

  base64 -i android/key.properties -o android/key.base64

  base64 -i android/verified.pem -o android/verified_pem.base64

  base64 -i lib/app_config.dart -o lib/app_config.base64

  base64 -i lib/helpers/security/nonce.private.dart -o lib/helpers/security/nonce_private.base64

  base64 -i server/nonce.js -o server/nonce.base64

  ```

### run backend server

- Single node Docker

```bash
    docker-compose build
    docker-compose -p verified up -d --force-recreate --build --remove-orphans --timestamps
    docker-compose down | docker stack rm verified
```

- Deploy with Docker Swarm
  ```bash
      docker login -u makhosi
      docker stack deploy -c docker-compose.yml --with-registry-auth --resolve-image=always verified
  ```
- then force re-update

  ```bash
    for name in $(docker stack services --format '{{.Name}}' verified); do
      echo "UPDATE => $name:"
      docker service update --force "$name"
      echo ""
    done

  ```

### Build

- ```bash
    docker build -t makhosi/{{image}}:1.0.0 -t makhosi/{{image}}:latest . --platform="linux/amd64"
  ```

### Apple Push Notification

- Trigger a Apple Push Notification; `xcrun simctl push booted com.byteestudio.Verified ios/push.json`

### Apple trigger deep-link click

- `/usr/bin/xcrun simctl openurl booted "app://byteestudio.com/foo/secure/123e4567-e89b-12d3-a456-426614174000/123e4567-e89b-12d3-a456-426614174000"`

### Android trigger deep-link click

- `adb shell am start -a android.intent.action.VIEW  -d "app://byteestudio.com/foo/secure/89b-12d3-a456-426614174000/123e4567-e89b-12d3-a456-426614174000" `

## buddle and merge certs

- `cd localhost`
- `cd verified.byteestudio.com`
- `cat certificate.crt ca_bundle.crt >> merged_certificate.crt`

## firebase analytics debug view

- ```bash
  adb shell setprop log.tag.FA VERBOSE
  adb shell setprop log.tag.FA-SVC VERBOSE
  adb logcat -v time -s FA FA-SVC
  adb shell setprop debug.firebase.analytics.app "com.byteestudio.verified"
  ```

### check-out

- https://regulaforensics.com
- https://usesmileid.com
- https://regulaforensics.com
- https://verifyid.co.za
- https://dha.gov.za
- https://www.mie.co.za
- https://connect.iidentifii.com/

- Build temp images for deployment:

  - ```bash
    docker build -t makhosi/verified_cdn:latest -f ./apps/cdn/Dockerfile .;docker push makhosi/verified_cdn:latest
    docker build -t makhosi/verified_verify_id:latest -f ./apps/verifyId/Dockerfile .;docker push makhosi/verified_verify_id:latest
    docker build -t makhosi/verified_nginx:latest -f ./apps/nginx_proxy/Dockerfile .;docker push makhosi/verified_nginx:latest
    docker build -t makhosi/verified_store:latest -f ./apps/store/Dockerfile .;docker push makhosi/verified_store:latest
    docker build -t makhosi/verified_payments:latest -f ./apps/payments/Dockerfile .;docker push makhosi/verified_payments:latest
    ```

  ```

  ```

- export .env
  ```bash
    eval $(cat .env | sed 's/^/export /')
  ```

# Server lock-down

### Enable UFW

```bash
sudo ufw enable


sudo ufw allow 22        # SSH
sudo ufw allow 53        # DNS
sudo ufw allow 123       # NTP
sudo ufw allow 67/udp    # DHCP
sudo ufw allow 68/udp    # DHCP (client-side)


sudo ufw allow 8086
sudo ufw allow 8883
sudo ufw allow 18083
sudo ufw allow 1883
sudo ufw allow 8083
sudo ufw allow 8084
sudo ufw allow 2202
sudo ufw allow 443       # HTTPS
sudo ufw allow 80        # HTTP
sudo ufw allow 8000
sudo ufw allow 9443


sudo ufw default deny incoming
sudo ufw default allow outgoing

# Check UFW Status

sudo ufw status numbered

# Reload UFW

sudo ufw reload

```

### create log files
- `touch /var/log/nginx/bots.log;touch /var/log/nginx/banned.log`

### fail to ban

```bash
# Update System and Install Fail2Ban

sudo apt update
sudo apt install fail2ban -y

# Start and Enable Fail2Ban Service

sudo systemctl start fail2ban
sudo systemctl enable fail2ban

# Create a Local Jail Configuration (jail.local)

sudo nano /etc/fail2ban/jail.local ## Ban settings

# Restart Fail2Ban

sudo systemctl restart fail2ban

## Check Status
sudo fail2ban-client status

## To check the status of a specific jail (e.g., SSH):
sudo fail2ban-client status sshd

## Unban an IP (if needed)

sudo fail2ban-client set <JAIL_NAME> unbanip <IP_ADDRESS>

## jail SSH:

sudo fail2ban-client set sshd unbanip 192.168.1.100

## Monitoring and Logs
sudo tail -f /var/log/fail2ban.log

##  List Currently Banned IPs:

sudo fail2ban-client banned


```
- Ban settings**/etc/fail2ban/jail.local**

```conf
[DEFAULT]
bantime = -1
findtime = 600
maxretry = 5
action = %(action_)s

[sshd]
enabled = true
port = 22
filter = sshd
logpath = /var/log/auth.log
maxretry = 3

[nginx-http-auth]
enabled = true
port = 80,443
filter = nginx-http-auth
logpath = /var/log/nginx/banned.log
maxretry = 3

[apache-auth]
enabled = true
port = 80,443
filter = apache-auth
logpath = /var/log/apache2/error.log
maxretry = 3

[vsftpd]
enabled = true
port = 21
filter = vsftpd
logpath = /var/log/vsftpd.log
maxretry = 3

[mysqld-auth]
enabled = true
port = 3306
filter = mysqld-auth
logpath = /var/log/mysql/error.log
maxretry = 3


[postfix-sasl]
enabled = true
port = smtp,submissions,465
filter = postfix[mode=auth]
logpath = /var/log/mail.log
maxretry = 3

[dovecot]
enabled = true
port = pop3,pop3s,imap,imaps
filter = dovecot
logpath = /var/log/mail.log
maxretry = 3


[nginx-404]
enabled = true
port = 80,443
filter = nginx-404
logpath = /var/log/nginx/bots.log
maxretry = 10


[recidive]
enabled = true
logpath = /var/log/fail2ban.log
bantime = -1
findtime = 86400
maxretry = 3
```
