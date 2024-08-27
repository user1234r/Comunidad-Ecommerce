<?php

namespace App\Controllers;

use CodeIgniter\Controller;

class DashboardController extends Controller
{
    public function artesano()
    {
        if (session()->get('ID_Rol') != 1) {
            return redirect()->to(base_url('login'));
        }
        return view('dashboard/artesano');
    }

    public function cliente()
    {
        if (session()->get('ID_Rol') != 2) {
            return redirect()->to(base_url('login'));
        }
        return view('dashboard/cliente');
    }

    public function delivery()
    {
        if (session()->get('ID_Rol') != 3) {
            return redirect()->to(base_url('login'));
        }
        return view('dashboard/delivery');
    }

    public function admin()
    {
        if (session()->get('ID_Rol') != 4) {
            return redirect()->to(base_url('login'));
        }
        return view('dashboard/admin');
    }
}