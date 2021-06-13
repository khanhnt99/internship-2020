# CachetHQ
## 1. Tổng quan
- `Cachet` là công cụ thủ công, hệ thống trạng thái mã nguồn mở giúp quản trị viên hệ thống thông báo về sự cố và thời gian ngừng hoạt động của hệ thống, ứng dụng.
- Thông qua ứng dụng, người dùng có thể đo lường các trường hợp như tỉ lệ lỗi, thời gian hoạt động hoặc bất kì điều gì ngẫu nhiên. Chúng có độ phản hồi cao và hoạt động liền mạch trên mọi hệ thống.

## 2. Các tình trạng sự cố
- Cachet sử dụng sơ đồ đánh số dựa trên số 0 để xác định các trạng thái sự cố.

|Status|Name|Description|
|------|----|------------|
|0|Scheduled|Dành cho trạng thái đã lên lịch
|1|Investigating|Có báo cáo về sự cố và đang xem xét
|2|Identified|Thấy vấn đề và đang fix nó |
|3|Watching| Triển khai bản sửa lỗi và đang theo dõi tình hình
|4|Fixed|Sửa lỗi đã được thực hiện

## 3. Trạng thái thành phần
- Không giống như sự cố, các trạng thái của thành phần được đánh số từ 1. Khi tạo 1 `component` ta cần chỉ định trạng thái cho nó.

|Status|Name|Description|
|------|----|------------|
|1|Operational|Component đang chạy
|2|Performance Issues|Gặp sự cố chậm
|3|Partial Outage|Component không hoạt động với tất cả
|4|Major Outage|Component không hoạt động cho bất kì ai

