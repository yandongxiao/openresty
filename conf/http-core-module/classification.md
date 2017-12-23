# directives分类

# **接受请求**

- merge_slashes
- ignore_invalid_headers
- underscores_in_headers
- client_header_buffer_size
- client_header_timeout
- large_client_header_buffers
- max_ranges
- client_body_buffer_size
- client_body_temp_path
- client_max_body_size
-  **client_body_in_single_buffer** 
- client_body_timeout

# **处理请求**

- server
- listen-->reuseport
- server_name
- location
- limit_except
- internal
- alias
- root
- satisfy
- disable_symlinks
- index
- try_files
- error_page
- recursive_error_pages
- open_file_cache
- open_file_cache_valid
- open_file_cache_errors
- open_file_cache_min_uses
- resolver
- resolver_timeout
- log_not_found
- log_subrequest
- lingering_close
- lingering_timeout
- lingering_time

# **生成响应**

- tcp_nodelay
- tcp_nopush
- http--->keepalive
- output_buffers
- postpone_output
- default_type
- types
- hash_bucket_size
- hash_max_size
- server_tokens
- etag
- if_modified_since
- chunked_transfer_encoding
- keepalive_requests
- keepalive_timeout
- server_name_in_redirect
- port_in_redirect
- limit_rate
- limit_rate_after
- send_lowat
- send_timeout

# variables分类

# **Request**

- remote_user
- remote_addr
- remote_port
- server_name
- server_addr
- server_port
- scheme
- server_protocol
- request_length
- request
- request_method
- request_uri
- document_uri
- document_root
- realpath_root
- uri
- is_args
- args
- query_string
- arg_name
- http_name
- content-length
- content-type
- host
-  **request_body** 
-  **request_body_file** 

# **Response**

- nginx_version
- status
- time_local
- request_filename。文件不一定要存在
- request_time
- bytes_sent
- body_bytes_sent
- limie_rate
- pid
- connection
- connection_requests
