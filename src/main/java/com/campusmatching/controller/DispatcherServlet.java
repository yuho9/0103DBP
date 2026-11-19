
package com.campusmatching.controller;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;

@WebServlet(name = "dispatcherServlet", urlPatterns = "/", loadOnStartup = 1)

public class DispatcherServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private RequestMapping rm;

    @Override
    public void init() throws ServletException {
        rm = new RequestMapping();
        rm.initMapping();
    }

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String contextPath = request.getContextPath();
        String servletPath = request.getServletPath();

        Controller controller = rm.findController(servletPath);

        if (controller == null) {
            if (servletPath.startsWith("/css/")
                    || servletPath.startsWith("/assets/")
                    || servletPath.startsWith("/fonts/")) {

                request.getServletContext()
                       .getNamedDispatcher("default")
                       .forward(request, response);
                return;
            }

            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        try {
            String uri = controller.execute(request, response);

            if (uri.startsWith("redirect:")) {
                String targetUri = contextPath + uri.substring("redirect:".length());
                response.sendRedirect(targetUri);
            } else {
                String targetUri = uri;
                RequestDispatcher rd = request.getRequestDispatcher(targetUri);
                rd.forward(request, response);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
