============Create nodes on AWS============

        * S3 state store should be available before
        * cd to the project root
        * run -  kops-create-cluster.sh

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
        