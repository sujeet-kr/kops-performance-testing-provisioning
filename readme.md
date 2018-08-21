============Create nodes on AWS============

		* S3 state store should be available before
        * cd to the project root
        * run -  kops-create-cluster.sh

============Create EBS Persistance Volume on AWS for InfluxDB data persistance============

		* aws ec2 create-volume --size 10 --region us-east-2 --availability-zone us-east-2a --volume-type gp2 --tag-specifications 'ResourceType=volume,Tags=[{Key=KubernetesCluster,Value=sujeet.k8s.local}]'

============Delete the entire infrastructure ===========

		* cd to the project root
        * run - kops-delete-cluster.sh


============Delete the EBS volume ===========

		* aws ec2 delete-volume --volume-id <volume-id>

============Update the cluster specification============

		* Update the changes on sujeet.k8s.local.yaml
        * kops replace -f $NAME.yaml
        * kops update cluster $NAME --yes
        * kops rolling-update cluster $NAME --yes  (not mandatory)
        