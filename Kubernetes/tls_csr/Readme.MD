----------------------------
Step 1: Create a Private Key
----------------------------
openssl genrsa -out venu.key 2048

-------------------------------------------------
Step 2: Create a Certificate Signing Request (CSR)
--------------------------------------------------
openssl req -new -key venu.key -out venu.csr -subj "/CN=venu"

-----------------
Step 2.1
-------------------
cat venu.csr | base64 | tr -d "\n"


-------------------------------------------------------------
Step 3: Create a Kubernetes CSR Object and apply the yaml file
---------------------------------------------------------------
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: <name-csr>
spec:
  request: <BASE64_ENCODED_CSR> copy the 2.1 code here
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth

-------------------------------------
Step 5: Approve the CSR
-------------------------
kubectl certificate approve <name-csr>  #to approve
kubectl certificate deny <name-csr>     #to deny

----------------------------------
Step 6: Retrieve the Signed Certificate
----------------------------------------
kubectl get csr my-tls-csr -o jsonpath='{.status.certificate}' | base64 --decode > venu.crt













