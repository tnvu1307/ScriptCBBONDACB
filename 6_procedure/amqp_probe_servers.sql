SET DEFINE OFF;
CREATE OR REPLACE procedure amqp_probe_servers
(brokerId IN number)
as language java
name 'com.zenika.oracle.amqp.RabbitMQPublisher.amqpProbeAllServers(int)';
/
