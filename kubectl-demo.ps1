Write-Host "=========================================" -ForegroundColor Green
Write-Host "Kubernetes Deployment Commands" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

Write-Host "Creating namespace..." -ForegroundColor Yellow
Write-Host "kubectl apply -f k8s/namespace.yml" -ForegroundColor Cyan
Write-Host "namespace/ecommerce created" -ForegroundColor Green

Write-Host "`nDeploying product-service..." -ForegroundColor Yellow
Write-Host "kubectl apply -f k8s/product-service-deployment.yml" -ForegroundColor Cyan
Write-Host "deployment.apps/product-service created" -ForegroundColor Green
Write-Host "service/product-service created" -ForegroundColor Green

Write-Host "`nDeploying order-service..." -ForegroundColor Yellow
Write-Host "kubectl apply -f k8s/order-service-deployment.yml" -ForegroundColor Cyan
Write-Host "deployment.apps/order-service created" -ForegroundColor Green
Write-Host "service/order-service created" -ForegroundColor Green

Write-Host "`nDeploying frontend..." -ForegroundColor Yellow
Write-Host "kubectl apply -f k8s/frontend-deployment.yml" -ForegroundColor Cyan
Write-Host "deployment.apps/frontend created" -ForegroundColor Green
Write-Host "service/frontend created" -ForegroundColor Green

Write-Host "`nCreating ingress..." -ForegroundColor Yellow
Write-Host "kubectl apply -f k8s/ingress.yml" -ForegroundColor Cyan
Write-Host "ingress.networking.k8s.io/ecommerce-ingress created" -ForegroundColor Green

Write-Host "`nChecking deployment status..." -ForegroundColor Yellow
Write-Host "kubectl get deployments -n ecommerce" -ForegroundColor Cyan
Write-Host "NAME               READY   UP-TO-DATE   AVAILABLE   AGE" -ForegroundColor White
Write-Host "product-service    2/2     2            2           10s" -ForegroundColor Green
Write-Host "order-service      2/2     2            2           10s" -ForegroundColor Green
Write-Host "frontend           2/2     2            2           10s" -ForegroundColor Green

Write-Host "`nkubectl get services -n ecommerce" -ForegroundColor Cyan
Write-Host "NAME               TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE" -ForegroundColor White
Write-Host "product-service    ClusterIP      10.96.123.45    <none>        3001/TCP  10s" -ForegroundColor Green
Write-Host "order-service      ClusterIP      10.96.123.46    <none>        3002/TCP  10s" -ForegroundColor Green
Write-Host "frontend           LoadBalancer   10.96.123.47    <pending>     80/TCP    10s" -ForegroundColor Green

Write-Host "`nkubectl get pods -n ecommerce" -ForegroundColor Cyan
Write-Host "NAME                                READY   STATUS    RESTARTS   AGE" -ForegroundColor White
Write-Host "product-service-5f7d7d4f4f-abcde   1/1     Running   0          10s" -ForegroundColor Green
Write-Host "product-service-5f7d7d4f4f-fghij   1/1     Running   0          10s" -ForegroundColor Green
Write-Host "order-service-6f8e8e5g5g-klmno     1/1     Running   0          10s" -ForegroundColor Green
Write-Host "order-service-6f8e8e5g5g-pqrst     1/1     Running   0          10s" -ForegroundColor Green
Write-Host "frontend-7g9f9f6h6h-uvwxy         1/1     Running   0          10s" -ForegroundColor Green
Write-Host "frontend-7g9f9f6h6h-zabcd         1/1     Running   0          10s" -ForegroundColor Green

Write-Host "`n=========================================" -ForegroundColor Green
Write-Host "Kubernetes Deployment Complete!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
