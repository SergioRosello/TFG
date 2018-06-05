import dbus
import sys
import os


if __name__ == '__main__':
    # The *system bus* is global and usually started during boot; it's used to
    # communicate with system services like udev_, NetworkManager_, and the
    # `Hardware Abstraction Layer daemon (hald)`_.
    bus = dbus.SystemBus()

    # To obtain a proxy object, call the ``get_object`` method on the ``Bus``.
    # For example, NetworkManager_ has the well-known name
    # ``org.freedesktop.NetworkManager`` and exports an object whose object
    # path is ``/org/freedesktop/NetworkManager``, plus an object per network
    # interface at object paths like
    # ``dwworkManager/Devices/eth0``. You can get a proxy
    # for the object representing eth0 like this.
    # proxy = bus.get_object('org.freedesktop.NetworkManager', '/org/freedesktop/NetworkManager/Devices/eth0')

    # Well known name: org.freedesktop.login1
    # Object path: /org/freedesktop/login1
    mgr = bus.get_object('org.freedesktop.login1', '/org/freedesktop/login1')
    # An interface is a group of related methods and signals (more on signals later), 
    # identified by a name which is a series of dot-separated components starting with a reversed domain name
    mgr_iface = dbus.Interface(mgr, dbus_interface='org.freedesktop.login1.Manager')
    user = bus.get_object('org.freedesktop.login1', mgr_iface.GetUserByPID(os.getpid()))
    uuid = user.Get('org.freedesktop.login1.User', 'UID', dbus_interface='org.freedesktop.DBus.Properties')
    print (uuid)
