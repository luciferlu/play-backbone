package controllers;

import java.io.IOException;
import java.io.StringWriter;

import play.*;
import play.mvc.*;

import static play.libs.Json.toJson;
import org.codehaus.jackson.JsonNode;

import play.mvc.BodyParser;
import views.html.*;

import me.ezcode.pojo.User;

public class UserServices extends Controller {
  
    public static Result getUser(String userId) {
        User user = User.USERS.get(userId);
        return ok(toJson(user));
    }

    @BodyParser.Of(BodyParser.Json.class)
    public static Result saveUser(String userId){
        JsonNode json = request().body().asJson();
        String name = json.findPath("name").getTextValue();
        User user = User.USERS.get(userId);
        user.setName(name);

        return ok(toJson(user));
    }
}
