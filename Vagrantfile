Vagrant.configure("2") do |config|
  
    # 매니지드 서버 설정
    NODE_COUNT = 2
    NODE_COUNT.times do |i|
        config.vm.define "managed1#{i}" do |managed|
        managed.vm.box = "centos/7"
        managed.vm.hostname = "managed1#{i}"
        managed.vm.network "private_network", ip: "172.16.74.10#{i}"
        managed.vm.provider "virtualbox" do |vb|
            vb.memory = "1024"
            vb.cpus = 1
        end
        managed.vm.provision "shell", inline: <<-SHELL
            # Centos 7 has reached EOL (End of Life) today, 1 July 2024
            sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/*.repo
            sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/*.repo
            sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/*.repo
            sudo yum -y update
            sudo yum -y install git net-tools
            
            # root 비밀번호 설정
            echo "root:1123" | sudo chpasswd

            # SSH 설정 변경
            sudo sed -i 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
            sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
            sudo systemctl restart sshd

        SHELL
        end
    end

    # # 매니지드 서버 설정
    NODE_COUNT = 2
    NODE_COUNT.times do |i|
        config.vm.define "managed2#{i}" do |managed|
        managed.vm.box = "ubuntu/bionic64"
        managed.vm.hostname = "managed2#{i}"
        managed.vm.network "private_network", ip: "172.16.74.20#{i}"
        managed.vm.provider "virtualbox" do |vb|
            vb.memory = "1024"
            vb.cpus = 1
        end
        managed.vm.provision "shell", inline: <<-SHELL
            # sudo echo "nameserver 8.8.8.8" > /etc/resolv.conf
            sudo apt -y update
            sudo apt -y install git net-tools
            
            # root 비밀번호 설정
            echo "root:1123" | sudo chpasswd

            # SSH 설정 변경
            sudo sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
            sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
            sudo systemctl restart sshd

        SHELL
        end
    end

    # 컨트롤 서버 설정
    # config.vm.define "control" do |control|
    #     control.vm.box = "centos/7"
    #     control.vm.hostname = "control"
    #     control.vm.network "private_network", ip: "172.16.74.10"
    #     control.vm.provider "virtualbox" do |vb|
    #         vb.memory = "1024"
    #         vb.cpus = 2
    #     end
    #     control.vm.provision "shell", inline: <<-SHELL
    #         # sudo echo "nameserver 8.8.8.8" > /etc/resolv.conf
    #         sudo yum -y update
    #         sudo yum -y install epel-release
    #         sudo yum -y install net-tools vim jq
    #         sudo yum remove docker \
    #               docker-client \
    #               docker-client-latest \
    #               docker-common \
    #               docker-latest \
    #               docker-latest-logrotate \
    #               docker-logrotate \
    #               docker-engine
    #         sudo yum install -y yum-utils
    #         sudo yum install -y gcc python3
    #         sudo yum install -y python3-pip
    #         sudo yum install -y curl net-tools vim
    #         sudo yum install -y openssh-server sshpass
    #         sudo yum clean all
    #         sudo pip3 install --upgrade pip
    #         sudo pip3 install ansible 
    #         sudo pip3 install jinja2
    #         sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    #         sudo yum -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    #         curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    #         chmod +x /usr/local/bin/docker-compose
    #         sudo systemctl start docker
    #         sudo systemctl enable docker
    #         docker-compose --version
    #         sudo docker run hello-world
            
    #         # root 비밀번호 설정
    #         echo "root:1123" | sudo chpasswd

    #         # SSH 설정 변경
    #         sudo sed -i 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
    #         sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    #         sudo systemctl restart sshd
    #     SHELL
    #     end
    # 컨트롤 서버 설정
    config.vm.define "control" do |control|
        control.vm.box = "ubuntu/bionic64" # Ubuntu 18.04 LTS
        control.vm.hostname = "control"
        control.vm.network "private_network", ip: "172.16.74.10"
        control.vm.provider "virtualbox" do |vb|
            vb.memory = "1024"
            vb.cpus = 2
        end
        control.vm.provision "shell", inline: <<-SHELL
            # 네임서버 설정 (필요시 주석 해제)
            # echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
    
            # 패키지 목록 업데이트 및 필수 패키지 설치
            sudo apt-get update
            sudo apt-get -y upgrade
            sudo apt-get -y install software-properties-common
            sudo apt-get -y install net-tools vim jq
    
            # Docker 설치 관련 기존 패키지 제거
            sudo apt-get -y remove docker docker-engine docker.io containerd runc
    
            # Docker 설치
            sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
            sudo add-apt-repository \
               "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
               $(lsb_release -cs) \
               stable"
            sudo apt-get update
            sudo apt-get -y install docker-ce docker-ce-cli containerd.io
    
            # Docker Compose 설치
            sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
            sudo chmod +x /usr/local/bin/docker-compose
    
            # Docker 시작 및 부팅 시 자동 시작 설정
            sudo systemctl start docker
            sudo systemctl enable docker
    
            # Docker 작동 확인
            sudo docker run hello-world
    
            # Python 및 Ansible 설치
            sudo apt-get -y install python3 python3-pip
            sudo pip3 install --upgrade pip
            sudo pip3 install ansible
            sudo pip3 install jinja2
    
            # root 비밀번호 설정
            echo "root:1123" | sudo chpasswd
    
            # SSH 설정 변경
            sudo sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
            sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
            sudo systemctl restart sshd
        SHELL
    end
    
end
  