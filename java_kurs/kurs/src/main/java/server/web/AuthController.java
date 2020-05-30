package server.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import server.entity.DbUser;
import server.repository.UserRepository;
import server.security.jwt.JwtTokenProvider;


import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/dc/auth")
public class AuthController {

    @Autowired
    AuthenticationManager authenticationManager;

    @Autowired
    JwtTokenProvider jwtTokenProvider;

    @Autowired
    UserRepository userRepository;

    @Autowired
    PasswordEncoder passwordEncoder;

    @PostMapping("/signin")
    public ResponseEntity signIn(@RequestBody AuthRequest request) {
        try {
            String userName = request.getUserName();
            DbUser dbUser = userRepository.findUsersByUserName(userName).orElseThrow(() -> new UsernameNotFoundException("Not Found"));
            String token = jwtTokenProvider.createToken(userName,
                    userRepository.findUsersByUserName(userName)
                            .orElseThrow(() -> new UsernameNotFoundException("User not found")).getRoles());
            if(!passwordEncoder.matches(request.getPassword(), dbUser.getPassword())) {
                throw new BadCredentialsException("Invalid password");
            }
            Map<Object, Object> model = new HashMap<>();
            model.put("userName", userName);
            model.put("token", token);

            return ResponseEntity.ok(model);
        } catch (AuthenticationException ex) {
            throw new BadCredentialsException("Invalid username or password");
        }
    }

}
