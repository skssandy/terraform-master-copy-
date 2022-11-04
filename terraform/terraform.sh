
echo "Enter the environment name (dev, demo, stage, prod)"
read ENV
echo "Selected environment is ${ENV}"
terraform init -reconfigure \
    -backend-config="bucket=tf-state-goboxtf" \
    -backend-config="key=${ENV}/gobox-tfstate" \
    -backend-config="region=us-east-2"
echo "Enter an action (plan, apply or destroy)"
read ACTION
if [ ${ACTION} = "plan" ]
then
   terraform plan -var-file=tf_env/${ENV}.tfvars 
elif [ ${ACTION} = "apply" ]
then
   terraform apply -var-file=tf_env/${ENV}.tfvars -auto-approve
elif [ ${ACTION} = "destroy" ]
then
   terraform destroy -var-file=tf_env/${ENV}.tfvars -auto-approve
else
   echo "Wrong input for action"
fi
