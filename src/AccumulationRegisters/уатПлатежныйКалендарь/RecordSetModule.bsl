
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	//Если ПолучитьФункциональнуюОпцию("уатИспользоватьПлатежныйКалендарь") = Истина Тогда
	//	СтарыйНабор = РегистрыНакопления.уатПлатежныйКалендарь.СоздатьНаборЗаписей();
	//	Для Каждого ЭлементОтбора Из Отбор Цикл
	//		Если ЭлементОтбора.Использование Тогда
	//			СтарыйНабор.Отбор[ЭлементОтбора.Имя].Установить(ЭлементОтбора.Значение);
	//		КонецЕсли;
	//	КонецЦикла;
	//	СтарыйНабор.Прочитать();
	//	
	//	мсвЗаказы = Новый Массив;
	//	Для Каждого СтрокаНабора Из СтарыйНабор Цикл  
	//		Если мсвЗаказы.Найти(СтрокаНабора.ЗаказНаТС) <> Неопределено Тогда
	//			Продолжить;
	//		КонецЕсли;
	//		
	//		мсвЗаказы.Добавить(СтрокаНабора.ЗаказНаТС); 
	//	КонецЦикла;
	//	
	//	ДополнительныеСвойства.Вставить("ЗаказыВНаборе", мсвЗаказы);
	//КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	//Если ПолучитьФункциональнуюОпцию("уатИспользоватьПлатежныйКалендарь") = Истина 
	//	И ДополнительныеСвойства.Свойство("ЗаказыВНаборе") Тогда
	//	уатПроведение_проф.ОбновитьТекущееСостояниеОплатыЗаказов(ДополнительныеСвойства.ЗаказыВНаборе);
	//КонецЕсли;
	
КонецПроцедуры

#КонецОбласти