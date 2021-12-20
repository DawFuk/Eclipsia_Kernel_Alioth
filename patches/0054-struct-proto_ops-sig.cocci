/*
This provides the backport for the collateral evolution introduced
via commit 1b784140474e4fc94281a49e96c67d29df0efbde, titled
"net: Remove iocb argument from sendmsg and recvmsg".

The net/tipc/ subsystem (Transparent Inter Process Communication (TIPC))
relied historically on using an argument passed on the struct proto_ops
and struct proto sendmsg and recvmsg callbacks to determine if it needed
to perform a lock within its own code. Commit 1b784140474e4 removed replaced
the locking functionality to require the argument and instead moved all
the necessary heuristics into net/tipc. Other subsystems just passed NULL.
After the net/tipc code was cleaned up from the locking (see commmit
39a0295f901423e260a034ac7c3211ecaa9c2745 titled "tipc: Don't use iocb
argument in socket layer") we no longer needed the extra argument on the
struct proto_ops and struct proto callbacks.

To backport non-tipc subsystems we then just need to modify the upstream
code which declares these callbacks and add the extra argument again, but
the same routine can be used from upstream code. The grammar we use below
declares routines which can be pegged to struct proto_ops and struct proto
callbacks that simply call the same upstream code, the extra argument is
ignored. The argument can be ignored as it was only used within the
net/tipc subsystem for locking purposes.
*/

@ proto_ops @
identifier s, send_func, recv_func;
@@

 struct proto_ops s = {
 	.sendmsg = send_func,
 	.recvmsg = recv_func,
};

@ mod_send depends on proto_ops @
identifier proto_ops.send_func;
fresh identifier backport_send = "backport_" ## send_func;
@@

send_func(...)
{
	...
}

+#if LINUX_VERSION_IS_LESS(4,1,0)
+static int backport_send(struct kiocb *iocb, struct socket *sock, struct msghdr *msg, size_t len)
+{
+	return send_func(sock, msg, len);
+}
+#endif /* LINUX_VERSION_IS_LESS(4,1,0) */

@ mod_recv depends on proto_ops @
identifier proto_ops.recv_func;
fresh identifier backport_recv = "backport_" ## recv_func;
@@

recv_func(...)
{
	...
}

+#if LINUX_VERSION_IS_LESS(4,1,0)
+static int backport_recv(struct kiocb *iocb, struct socket *sock,
+			  struct msghdr *msg, size_t len, int flags)
+{
+	return recv_func(sock, msg, len, flags);
+}
+#endif /* LINUX_VERSION_IS_LESS(4,1,0) */

@ mod_proto_ops_tx depends on proto_ops && mod_send @
identifier s, proto_ops.send_func, mod_send.backport_send;
@@

 struct proto_ops s = {
+#if LINUX_VERSION_IS_GEQ(4,1,0)
 	.sendmsg = send_func,
+#else
+	.sendmsg = backport_send,
+#endif /* LINUX_VERSION_IS_GEQ(4,1,0) */
};

@ mod_proto_ops_rx depends on proto_ops && mod_recv @
identifier s, proto_ops.recv_func, mod_recv.backport_recv;
@@

 struct proto_ops s = {
+#if LINUX_VERSION_IS_GEQ(4,1,0)
 	.recvmsg = recv_func,
+#else
+	.recvmsg = backport_recv,
+#endif /* LINUX_VERSION_IS_GEQ(4,1,0) */
};

@ mod_sock_send_callers depends on proto_ops@
identifier proto_ops.send_func;
identifier sock, msg, len, sk;
@@

send_func(struct socket *sock, struct msghdr *msg, size_t len)
{
	...
+#if LINUX_VERSION_IS_GEQ(4,1,0)
	return sk->sk_prot->sendmsg(sk, msg, len);
+#else
+	return sk->sk_prot->sendmsg(NULL, sk, msg, len);
+#endif /* LINUX_VERSION_IS_GEQ(4,1,0) */
}

@ proto @
identifier s, send_func, recv_func;
@@

 struct proto s = {
 	.sendmsg = send_func,
 	.recvmsg = recv_func,
};

@ proto_mod_send depends on proto @
identifier proto.send_func;
fresh identifier backport_send = "backport_" ## send_func;
@@

send_func(...)
{
	...
}

+#if LINUX_VERSION_IS_LESS(4,1,0)
+static int backport_send(struct kiocb *iocb, struct sock *sk,
+			  struct msghdr *msg, size_t len)
+{
+	return send_func(sk, msg, len);
+}
+#endif /* LINUX_VERSION_IS_LESS(4,1,0) */

@ proto_mod_recv depends on proto @
identifier proto.recv_func;
fresh identifier backport_recv = "backport_" ## recv_func;
@@

recv_func(...)
{
	...
}

+#if LINUX_VERSION_IS_LESS(4,1,0)
+static int backport_recv(struct kiocb *iocb, struct sock *sk,
+			  struct msghdr *msg, size_t len,
+			  int noblock, int flags, int *addr_len)
+{
+	return recv_func(sk, msg, len, noblock, flags, addr_len);
+}
+#endif /* LINUX_VERSION_IS_LESS(4,1,0) */

@ mod_proto_tx depends on proto && proto_mod_send @
identifier s, proto.send_func, proto_mod_send.backport_send;
@@

 struct proto s = {
+#if LINUX_VERSION_IS_GEQ(4,1,0)
 	.sendmsg = send_func,
+#else
+	.sendmsg = backport_send,
+#endif /* LINUX_VERSION_IS_GEQ(4,1,0) */
};

@ mod_proto_rx depends on proto && proto_mod_recv @
identifier s, proto.recv_func, proto_mod_recv.backport_recv;
@@

 struct proto s = {
+#if LINUX_VERSION_IS_GEQ(4,1,0)
 	.recvmsg = recv_func,
+#else
+	.recvmsg = backport_recv,
+#endif /* LINUX_VERSION_IS_GEQ(4,1,0) */
};
