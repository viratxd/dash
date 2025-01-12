import React from 'react';
import { NavLink } from 'react-router-dom';
import { 
  LayoutGrid, 
  CreditCard, 
  Webhook, 
  Settings, 
  LogOut 
} from 'lucide-react';
import { useAuthStore } from '../../store/authStore';

const Sidebar = () => {
  const signOut = useAuthStore(state => state.signOut);

  const navItems = [
    { icon: LayoutGrid, label: 'Services', path: '/dashboard' },
    { icon: CreditCard, label: 'Transactions', path: '/dashboard/transactions' },
    { icon: Webhook, label: 'Webhooks', path: '/dashboard/webhooks' },
    { icon: Settings, label: 'Settings', path: '/dashboard/settings' },
  ];

  return (
    <div className="w-64 bg-white border-r border-gray-200 px-4 py-6">
      <div className="flex items-center mb-8">
        <LayoutGrid className="h-8 w-8 text-indigo-600" />
        <span className="ml-2 text-xl font-bold">SaaS Kit</span>
      </div>
      
      <nav className="space-y-2">
        {navItems.map((item) => (
          <NavLink
            key={item.path}
            to={item.path}
            className={({ isActive }) =>
              `flex items-center px-4 py-2 rounded-lg transition-colors ${
                isActive
                  ? 'bg-indigo-50 text-indigo-600'
                  : 'text-gray-600 hover:bg-gray-50'
              }`
            }
          >
            <item.icon className="h-5 w-5" />
            <span className="ml-3">{item.label}</span>
          </NavLink>
        ))}
      </nav>

      <div className="mt-auto pt-8">
        <button
          onClick={() => signOut()}
          className="flex items-center px-4 py-2 text-gray-600 hover:bg-gray-50 rounded-lg w-full"
        >
          <LogOut className="h-5 w-5" />
          <span className="ml-3">Logout</span>
        </button>
      </div>
    </div>
  );
};

export default Sidebar;