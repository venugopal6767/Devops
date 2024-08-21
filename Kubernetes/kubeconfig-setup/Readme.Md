Steps to create certificate for user
------------------------------------

1. openssl genrsa -out <user>.key 2048
2. openssl req -new -key <user>.key  -out <user>.csr -subj="/CN=<user>"
3. CSR=$(cat <user>.csr | base64 --wrap 0 )
   echo $CSR
4. create a file (sign-request.yml) and add the below content

apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: <user>
spec:
  request: $CSR
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400  # one day
  usages:
  - client auth

5. sed -i "s/\$CSR/$CSR/g" sign-request.yml
6. kubectl apply -f sign-request.yml
7. kubectl certificate approve <user>
8. kubectl get csr <user> -o jsonpath='{.status.certificate}'| base64 -d > <user>.crt
9. kubectl config set-credentials <user> --client-key=<user>.key --client-certificate=<user>.crt --embed-certs=true
10. kubectl config set-context <contextname> --cluster=<clustername> --user=<username>
11. kubectl config view
12. kubectl config get-contexts
13. kubectl config use-context <contextname>
    kubectl auth can-i get pod
    kubectl auth can-i create pod 

15. kubectl auth can-i list pods --as <user> -n <namespace>

create role and rolebinding to check 

apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
  namespace: default
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["list", "get", "watch"]


apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-reader-binding
  namespace: default
subjects:
- kind: User
  name: example-user  # Replace with the actual user name
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io


kubectl get config --minify
