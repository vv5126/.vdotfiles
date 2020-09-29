external_url 'http://192.168.3.3:800'

# 配置ssh协议所使用的访问地址和端口
gitlab_rails['gitlab_ssh_host'] = '192.168.3.3'
gitlab_rails['gitlab_shell_ssh_port'] = 222 # 此端口是run时22端口映射的222端口

gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "mail.ingenic.com"
gitlab_rails['smtp_port'] = 25
gitlab_rails['smtp_user_name'] = "wei.gao@ingenic.com"
gitlab_rails['smtp_password'] = "qwe123.GAO"
gitlab_rails['smtp_domain'] = "mail.ingenic.com"
gitlab_rails['smtp_authentication'] = "login"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_tls'] = true
gitlab_rails['gitlab_email_from'] = 'wei.gao@ingenic.com'
