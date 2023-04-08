
================================================================
Multi-Cluster, Multi-Cloud Networking for Kubernetes - OpenShift
================================================================

.. contents:: Table of Contents

Objective
################################



**Steps 1 - OCP Environment**


**Step 2 - Deploy Cloud Mesh Pod**

**Step 2 - Deploy Cloud Mesh Pod**

**Step 3 - Deploy Cloud Mesh Node**


**Step 4 - Deploy application on OpenShift**



Step 1 - OCP Environment
################################
1.1  Deploy/Ensure OpenShift Cluster and Ready

Building an OCP cluster is beyond the scope of this guide. Please refer to RedHat official documentation. Hence, assumption that you already have an existing OCP up and running. With minor changes, this instruction can be use for non-OCP – EKS, AKS and GKE.

Example of my OCP Environment used in this guide.

- ocp-au - 3 node cluster located in Australia DC
- ocp-sg - Single node cluster locatated in Singpaore DC
- ocp-hk - Single noe cluster located in Hong Kong DC

::

    fbchan@forest:~/ocp-au$ oc get node
    NAME                      STATUS   ROLES           AGE    VERSION
    ocp-au1.ocp.edgecnf.com   Ready    master,worker   163d   v1.22.8+9e95cb9
    ocp-au2.ocp.edgecnf.com   Ready    master,worker   163d   v1.22.8+9e95cb9
    ocp-au3.ocp.edgecnf.com   Ready    master,worker   163d   v1.22.8+9e95cb9
    
    fbchan@forest:~/ocp-sg$ oc get node
    NAME                     STATUS   ROLES           AGE    VERSION
    ocp-sg.ocp.edgecnf.com   Ready    master,worker   275d   v1.23.5+3afdacb
    
    fbchan@forest:~/ocp-hk$ oc get node
    NAME                     STATUS   ROLES           AGE    VERSION
    ocp-hk.ocp.edgecnf.com   Ready    master,worker   159d   v1.22.8+9e95cb9

1.2 Enable/Ensure kernel hugepages available and sufficient.

Note: Only the ocp-au cluster will be shown. Repeat similar task for ocp-sg and ocp-hk

::

    fbchan@forest:~/ocp-au$ oc get node ocp-au1.ocp.edgecnf.com -o jsonpath="{.status.allocatable.hugepages-2Mi}"
    0
    
    fbchan@forest:~/ocp-au$ oc get node ocp-au2.ocp.edgecnf.com -o jsonpath="{.status.allocatable.hugepages-2Mi}"
    0
    
    fbchan@forest:~/ocp-au$ oc get node ocp-au3.ocp.edgecnf.com -o jsonpath="{.status.allocatable.hugepages-2Mi}"
    0

Label nodes (e.g. worker node) with hugepages enabled. In this demo environment, master node also the worker nodes.

::

    fbchan@forest:~/ocp-au$ oc get node
    NAME                      STATUS   ROLES           AGE     VERSION
    ocp-au1.ocp.edgecnf.com   Ready    master,worker   163d    v1.22.8+9e95cb9
    ocp-au2.ocp.edgecnf.com   Ready    master,worker   163d   v1.22.8+9e95cb9
    ocp-au3.ocp.edgecnf.com   Ready    master,worker   163d   v1.22.8+9e95cb9
    
    oc label node ocp-au1.ocp.edgecnf.com node-role.kubernetes.io/worker-hp=
    oc label node ocp-au2.ocp.edgecnf.com node-role.kubernetes.io/worker-hp=
    oc label node ocp-au3.ocp.edgecnf.com node-role.kubernetes.io/worker-hp=
    
    fbchan@forest:~/ocp-au$ oc label node ocp-au1.ocp.edgecnf.com node-role.kubernetes.io/worker-hp=
    node/ocp-au1.ocp.edgecnf.com labeled
    fbchan@forest:~/ocp-au$ oc label node ocp-au2.ocp.edgecnf.com node-role.kubernetes.io/worker-hp=
    node/ocp-au2.ocp.edgecnf.com labeled
    fbchan@forest:~/ocp-au$ oc label node ocp-au3.ocp.edgecnf.com node-role.kubernetes.io/worker-hp=
    node/ocp-au3.ocp.edgecnf.com labeled
    
    fbchan@forest:~/ocp-au$ oc get node
    NAME                      STATUS   ROLES                     AGE     VERSION
    ocp-au1.ocp.edgecnf.com   Ready    master,worker,worker-hp   163d    v1.22.8+9e95cb9
    ocp-au2.ocp.edgecnf.com   Ready    master,worker,worker-hp   163d   v1.22.8+9e95cb9
    ocp-au3.ocp.edgecnf.com   Ready    master,worker,worker-hp   163d   v1.22.8+9e95cb9


Apply OCP tuned operator and machine config operator to enable hugepages.

1-hugepages-tuned-boottime.yaml

::

    apiVersion: tuned.openshift.io/v1
    kind: Tuned
    metadata:
      name: hugepages
      namespace: openshift-cluster-node-tuning-operator
    spec:
      profile:
      - data: |
          [main]
          summary=Boot time configuration for hugepages
          include=openshift-node
          [bootloader]
          cmdline_openshift_node_hugepages=hugepagesz=2M hugepages=1792
        name: openshift-node-hugepages
    
      recommend:
      - machineConfigLabels:
          machineconfiguration.openshift.io/role: "worker-hp"
        priority: 30
        profile: openshift-node-hugepages

2-hugepages-mcp.yaml

::

    apiVersion: machineconfiguration.openshift.io/v1
    kind: MachineConfigPool
    metadata:
      name: worker-hp
      labels:
        worker-hp: ""
    spec:
      machineConfigSelector:
        matchExpressions:
          - {key: machineconfiguration.openshift.io/role, operator: In, values: [worker,worker-hp]}
      nodeSelector:
        matchLabels:
          node-role.kubernetes.io/worker-hp: ""


::

    fbchan@forest:~/ocp-au$ oc create -f 1-hugepages-tuned-boottime.yaml
    tuned.tuned.openshift.io/hugepages created
    
    fbchan@forest:~/ocp-au$ oc create -f 2-hugepages-mcp.yaml
    machineconfigpool.machineconfiguration.openshift.io/worker-hp created

    
Depends on OCP version, if you have access to worker nodes, you can also enable hugepages by editing /etc/sysctl.conf. Example if you enable hugepage using sysctl instead of OCP tuned and mcp operator.

::

    sudo vi /etc/sysctl.conf
    vm.nr_hugepages = 1768
    
    sudo sysctl -p

Reboot worker nodes - if neccessary and validate hugepages

::

    fbchan@forest:~/ocp-au$ oc get node ocp-au1.ocp.edgecnf.com -o jsonpath="{.status.allocatable.hugepages-2Mi}"
    3536Mi
    
    fbchan@forest:~/ocp-au$ oc get node ocp-au2.ocp.edgecnf.com -o jsonpath="{.status.allocatable.hugepages-2Mi}"
    3536Mi
    
    fbchan@forest:~/ocp-au$ oc get node ocp-au3.ocp.edgecnf.com -o jsonpath="{.status.allocatable.hugepages-2Mi}"
    3536Mi


Do not continue until you have hugepages configured. Example above shown that I had hugepage configured.


1.3 Ensure StorageClass configured and Persistent Volume (PVC) working.

Deployment of CE site on K8S require persistent volume (PV). If you don’t have pv configured, here an example to deploy a NFS provisioner for OCP.

Assuming you already have an NFS server running (e.g. Linux NFS) on a remote server. In my example, 10.176.10.122 is my nfs server, /home/nfs is my nfs path

::

  helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/

  helm repo update
  
  oc create namespace openshift-nfs-storage
  
  oc label namespace openshift-nfs-storage "openshift.io/cluster-monitoring=true"
  
  helm install nfs nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
  --set nfs.server=10.176.10.122 \
  --set nfs.path=/home/nfs \
  --set storageClass.name=managed-nfs \
  --set storageClass.defaultClass=true \
  --set storageClass.onDelete=delete \
  -n openshift-nfs-storage --create-namespace
  
  oc patch storageclass managed-nfs -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/  is-default-class":"true"}}}'

Validate to make sure nfs pod is running

::

  fbchan@forest:~/ocp-au$ oc -n openshift-nfs-storage get pod
  NAME                                      READY   STATUS    RESTARTS   AGE
  nfs-client-provisioner-7cdf6c5f86-dkhkf   1/1     Running   26         152d
  
  fbchan@forest:~/ocp-au$ oc get sc
  NAME                    PROVISIONER                                   RECLAIMPOLICY   VOLUMEBINDINGMODE     ALLOWVOLUMEEXPANSION   AGE
  managed-nfs (default)   k8s-sigs.io/nfs-subdir-external-provisioner   Delete          Immediate             false                  152d

  
Use the sample statefulset manifest below to test to ensure PV and PVC working.

::

  apiVersion: apps/v1
  kind: StatefulSet
  metadata:
    name: busybox
  spec:
    serviceName: busybox
    replicas: 1
    selector:
      matchLabels:
        app: busybox
    template:
      metadata:
        labels:
          app: busybox
      spec:
        containers:
          - image: busybox
            args: [/bin/sh, -c, 'sleep 9999' ]
            volumeMounts:
              - mountPath: /test
                name: busybox-pvc
            name: busybox
    volumeClaimTemplates:
    - metadata:
        name: busybox-pvc
      spec:
        accessModes: [ "ReadWriteOnce" ]
        resources:
          requests:
            storage: 1Gi

Example output

::

  fbchan@forest:~/ocp-au$ oc apply -f busybox-pvc.yaml
  statefulset.apps/busybox created
  
  fbchan@forest:~/ocp-au$ oc get pvc
  NAME                    STATUS   VOLUME                                     CAPACITY   ACCESS MODES     STORAGECLASS   AGE
  busybox-pvc-busybox-0   Bound    pvc-08882259-4ca5-45ee-a426-a2ff69946dfa   1Gi        RWO              managed-nfs    49s
  
  fbchan@forest:~/ocp-au$ oc delete -f busybox-pvc.yaml
  statefulset.apps "busybox" deleted


Step 2 - Deploy Cloud Mesh Pod
################################

2.1  Download ce_k8s.yaml manifest.

2.2 Update ce_k8s.yaml deployment according to your env.

2.3 Apply ce_k8s.yaml deployment.

2.4 Approve registration of VER on F5 XC Console

2.5 Create ver-dns service

2.6 Update OCP DNS Operator to delegate domain to ver-dns


Step 3 - Deploy Cloud Mesh Node
####################################
3.1 Deploy Cloud Mesh Node.

3.2 Setup service discovery of Mesh Node to OCP

3.3 Create service account for Mesh node service discovery.

3.4 Setup pod network routing for ovn-kubernetes.

Step 4 - Deploy application on OpenShift
###############################################

4.1 Install Apps (Arcadia)

4.2 Create HTTP LB (origin pool, advertise policy, WAF policy, API Security)

4.3 Terraform

4.4 Install nginx web server.

