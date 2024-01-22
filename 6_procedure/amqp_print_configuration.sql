SET DEFINE OFF;
CREATE OR REPLACE procedure amqp_print_configuration
(brokerId IN number)
as language java
name 'com.zenika.oracle.amqp.RabbitMQPublisher.amqpPrintFullConfiguration(int)';
/
