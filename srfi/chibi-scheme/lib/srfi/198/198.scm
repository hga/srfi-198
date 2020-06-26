(define errno-map (make-hash-table))

(map (lambda (errno-number errno-symbol) (hash-table-set! errno-map errno-number errno-symbol))
     (list
      errno/E2BIG errno/EACCES errno/EADDRINUSE errno/EADDRNOTAVAIL
      errno/EAFNOSUPPORT errno/EAGAIN errno/EALREADY errno/EBADF
      errno/EBADMSG errno/EBUSY errno/ECANCELED errno/ECHILD
      errno/ECONNABORTED errno/ECONNREFUSED errno/ECONNRESET
      errno/EDEADLK errno/EDESTADDRREQ errno/EDOM errno/EDQUOT
      errno/EEXIST errno/EFAULT errno/EFBIG errno/EHOSTUNREACH
      errno/EIDRM errno/EILSEQ errno/EINPROGRESS errno/EINTR errno/EINVAL
      errno/EIO errno/EISCONN errno/EISDIR errno/ELOOP errno/EMFILE
      errno/EMLINK errno/EMSGSIZE errno/ENAMETOOLONG errno/ENETDOWN
      errno/ENETRESET errno/ENETUNREACH errno/ENFILE errno/ENOBUFS
      errno/ENODEV errno/ENOENT errno/ENOEXEC errno/ENOLCK errno/ENOMEM
      errno/ENOMSG errno/ENOPROTOOPT errno/ENOSPC errno/ENOSYS
      errno/ENOTCONN errno/ENOTDIR errno/ENOTEMPTY errno/ENOTRECOVERABLE
      errno/ENOTSOCK errno/ENOTSUP errno/ENOTTY errno/ENXIO
      errno/EOPNOTSUPP errno/EOVERFLOW errno/EOWNERDEAD errno/EPERM
      errno/EPIPE errno/EPROTO errno/EPROTONOSUPPORT errno/EPROTOTYPE
      errno/ERANGE errno/EROFS errno/ESPIPE errno/ESRCH errno/ESTALE
      errno/ETIMEDOUT errno/ETXTBSY errno/EWOULDBLOCK errno/EXDEV

      (cond-expand ((not bsd)
                    errno/EMULTIHOP errno/ENOLINK
                    ;; STREAMS:
                    errno/ENODATA errno/ENOSTR errno/ENOSR errno/ETIME)))

     (list
      'errno/E2BIG 'errno/EACCES 'errno/EADDRINUSE 'errno/EADDRNOTAVAIL
      'errno/EAFNOSUPPORT 'errno/EAGAIN 'errno/EALREADY 'errno/EBADF
      'errno/EBADMSG 'errno/EBUSY 'errno/ECANCELED 'errno/ECHILD
      'errno/ECONNABORTED 'errno/ECONNREFUSED 'errno/ECONNRESET
      'errno/EDEADLK 'errno/EDESTADDRREQ 'errno/EDOM 'errno/EDQUOT
      'errno/EEXIST 'errno/EFAULT 'errno/EFBIG 'errno/EHOSTUNREACH
      'errno/EIDRM 'errno/EILSEQ 'errno/EINPROGRESS 'errno/EINTR 'errno/EINVAL
      'errno/EIO 'errno/EISCONN 'errno/EISDIR 'errno/ELOOP 'errno/EMFILE
      'errno/EMLINK 'errno/EMSGSIZE 'errno/ENAMETOOLONG 'errno/ENETDOWN
      'errno/ENETRESET 'errno/ENETUNREACH 'errno/ENFILE 'errno/ENOBUFS
      'errno/ENODEV 'errno/ENOENT 'errno/ENOEXEC 'errno/ENOLCK 'errno/ENOMEM
      'errno/ENOMSG 'errno/ENOPROTOOPT 'errno/ENOSPC 'errno/ENOSYS
      'errno/ENOTCONN 'errno/ENOTDIR 'errno/ENOTEMPTY 'errno/ENOTRECOVERABLE
      'errno/ENOTSOCK 'errno/ENOTSUP 'errno/ENOTTY 'errno/ENXIO
      'errno/EOPNOTSUPP 'errno/EOVERFLOW 'errno/EOWNERDEAD 'errno/EPERM
      'errno/EPIPE 'errno/EPROTO 'errno/EPROTONOSUPPORT 'errno/EPROTOTYPE
      'errno/ERANGE 'errno/EROFS 'errno/ESPIPE 'errno/ESRCH 'errno/ESTALE
      'errno/ETIMEDOUT 'errno/ETXTBSY 'errno/EWOULDBLOCK 'errno/EXDEV

      (cond-expand ((not bsd)
                    'errno/EMULTIHOP 'errno/ENOLINK
                    ;; STREAMS:
                    'errno/ENODATA 'errno/ENOSTR 'errno/ENOSR 'errno/ETIME))
      ))

(define-record-type syscall-error
  (make-syscall-error errno message procedure-name syscall-name data)
  syscall-error?
  (errno syscall-error:errno)
  (message syscall-error:message)
  (procedure-name syscall-error:procedure-name)
  (syscall-name syscall-error:syscall-name)
  (data syscall-error:data))

(define (errno-error errno procedure-name syscall-name . data)
  (raise (make-syscall-error
          errno
          (string-append (symbol->string procedure-name)
                         " called "
                         (symbol->string syscall-name)
                         ": "
                         (symbol->string (errno-name errno))
                         ": "
                         (errno-string errno))
          procedure-name
          syscall-name
          data)))

(define (errno-string errno)
  ;; call %strerror_r
  #f
  )

(define (errno-name errno)
  (hash-table-ref errno-map errno))
