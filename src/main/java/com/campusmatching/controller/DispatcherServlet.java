
package com.campusmatching.controller;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "dispatcherServlet", urlPatterns = "/", loadOnStartup = 1)
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 10 * 1024 * 1024,
        maxRequestSize = 50 * 1024 * 1024
)
public class DispatcherServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private RequestMapping rm;

    @Override
    public void init() throws ServletException {
        rm = new RequestMapping();
        rm.initMapping();
    }

    @Override
    protected void service(HttpServletRequest request,
                           HttpServletResponse response)
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

            if (uri == null || response.isCommitted()) {
                return;
            }

            if (uri.startsWith("redirect:")) {
                String targetUri = contextPath
                        + uri.substring("redirect:".length());

                response.sendRedirect(targetUri);
                return;
            }

            RequestDispatcher rd =
                    request.getRequestDispatcher(uri);

            rd.forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
