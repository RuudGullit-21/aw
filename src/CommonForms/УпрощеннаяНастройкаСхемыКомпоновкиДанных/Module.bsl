
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	// Переданный в параметре адрес сохраняется в качестве адреса исходной схемы
	АдресИсходнойСхемыКомпоновкиДанных = Параметры.АдресСхемыКомпоновкиДанных;
	УникальныйИдентификаторВладельца = Параметры.УникальныйИдентификатор;
	
	// Заголовок формы
	Заголовок = Параметры.Заголовок;
	
	ИмяТекущегоШаблонаСКД           	  = Параметры.ИмяШаблонаСКД;
	ВозвращатьИмяТекущегоШаблонаСКД 	  = Параметры.ВозвращатьИмяТекущегоШаблонаСКД;
	ВозвращатьПолноеИмяТекущегоШаблонаСКД = Параметры.ВозвращатьПолноеИмяТекущегоШаблонаСКД;
	
	// Заполнение списка шаблонов
	Если НЕ Параметры.ИсточникШаблонов = Неопределено Тогда
		
		ПолноеИмяИсточникаШаблонов = ОбщегоНазначения.ИмяТаблицыПоСсылке(Параметры.ИсточникШаблонов);
		МенеджерИсточникаШаблонов = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Параметры.ИсточникШаблонов);
		
		Для каждого МакетШаблона Из МенеджерИсточникаШаблонов.ШаблоныСхемыКомпоновкиДанных() Цикл
			
			НоваяСтрока = Шаблоны.Добавить();
			НоваяСтрока.Синоним = МакетШаблона.Синоним;
			НоваяСтрока.Имя = МакетШаблона.Имя;
			Если МакетШаблона.Свойство("ПолноеИмяИсточникаШаблонов") И ЗначениеЗаполнено(МакетШаблона.ПолноеИмяИсточникаШаблонов) Тогда				
				НоваяСтрока.ПолноеИмяИсточникаШаблонов = МакетШаблона.ПолноеИмяИсточникаШаблонов;				
			Иначе
				НоваяСтрока.ПолноеИмяИсточникаШаблонов = ПолноеИмяИсточникаШаблонов;			
			КонецЕсли; 
			НоваяСтрока.ПолноеИмя = НоваяСтрока.ПолноеИмяИсточникаШаблонов + "." + НоваяСтрока.Имя;
			Если ВозвращатьПолноеИмяТекущегоШаблонаСКД Тогда
				Элементы.ТекущийШаблонСхемыКомпоновкиДанных.СписокВыбора.Добавить(НоваяСтрока.ПолноеИмя, НоваяСтрока.Синоним);
			Иначе
				Элементы.ТекущийШаблонСхемыКомпоновкиДанных.СписокВыбора.Добавить(НоваяСтрока.Имя, НоваяСтрока.Синоним);
			КонецЕсли; 			
		КонецЦикла;
		
		Если ПустаяСтрока(ИмяТекущегоШаблонаСКД) Тогда
			
			Элементы.ТекущийШаблонСхемыКомпоновкиДанных.СписокВыбора.Добавить("", НСтр("en='Arbitrary';ru='Произвольная'"));
			
		КонецЕсли;
		
		ТекущийШаблонСхемыКомпоновкиДанных = ИмяТекущегоШаблонаСКД;
		Элементы.ТекущийШаблонСхемыКомпоновкиДанных.Видимость = Истина;
		
	Иначе
		
		Элементы.ТекущийШаблонСхемыКомпоновкиДанных.Видимость = Ложь;
		
	КонецЕсли;
	
	// Исходная схема компоновки данных копируется в редактируемую схему компоновки данных
	СкопироватьСхемуКомпоновкиДанных(АдресРедактируемойСхемыКомпоновкиДанных, АдресИсходнойСхемыКомпоновкиДанных);
	
	// Компоновщик настроек инициализируется редактируемой схемой компоновки данных
	ИнициализироватьКомпоновщикНастроек(КомпоновщикНастроек, АдресРедактируемойСхемыКомпоновкиДанных, Параметры.АдресНастроекКомпоновкиДанных);
	
	Элементы.РедактироватьСхемуКомпоновки.Видимость = Не Параметры.НеРедактироватьСхемуКомпоновкиДанных;
	Элементы.ФормаЗагрузитьСхемуИзФайла.Видимость   = Не Параметры.НеЗагружатьСхемуКомпоновкиДанныхИзФайла;
	
	Элементы.ГруппаОтбор.Видимость                  = Не Параметры.НеНастраиватьОтбор;
	Элементы.ГруппаПараметры.Видимость              = Не Параметры.НеНастраиватьПараметры;
	Элементы.ГруппаПорядок.Видимость                = Не Параметры.НеНастраиватьПорядок;
	Элементы.ГруппаУсловноеОформление.Видимость     = Не Параметры.НеНастраиватьУсловноеОформление;
	Элементы.ГруппаПоля.Видимость                   = Не Параметры.НеНастраиватьВыбор;
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Элементы.РедактироватьСхемуКомпоновки.Видимость = Ложь;
		Элементы.ФормаЗагрузитьСхемуИзФайла.Видимость = Ложь;
	КонецЕсли; 
	НеПомещатьНастройкиВСхемуКомпоновкиДанных = Параметры.НеПомещатьНастройкиВСхемуКомпоновкиДанных;
	
	Элементы.ФормаЗагрузитьСхемуИзФайла.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзмененаСхемаКомпоновкиДанных(Форма, СхемаКомпоновкиДанных)
	
	// Получена схема из конструктора схемы компоновки данных
	Форма.Модифицированность = Истина;
	Форма.РедактируемаяСхемаКомпоновкиДанныхМодифицированность = Истина;
	
	// Редактируемая схема компоновки данных замещается схемой, полученной из конструктора
	БылиИзменения = Ложь;
	УстановитьСхемуКомпоновкиДанных(Форма.АдресРедактируемойСхемыКомпоновкиДанных, СхемаКомпоновкиДанных, Истина, БылиИзменения);
	
	Если БылиИзменения Тогда
		
		Если Форма.Элементы.ТекущийШаблонСхемыКомпоновкиДанных.СписокВыбора.НайтиПоЗначению("") = Неопределено Тогда
			Форма.Элементы.ТекущийШаблонСхемыКомпоновкиДанных.СписокВыбора.Добавить("", НСтр("en='Arbitrary';ru='Произвольная'"));
		КонецЕсли;
		
		Форма.ИмяТекущегоШаблонаСКД = "";
		Форма.ТекущийШаблонСхемыКомпоновкиДанных = Форма.ИмяТекущегоШаблонаСКД;
		
	КонецЕсли;
	
	// Компоновщик настроек инициализируется редактируемой схемой
	ИнициализироватьКомпоновщикНастроек(Форма.КомпоновщикНастроек, Форма.АдресРедактируемойСхемыКомпоновкиДанных);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	#Если ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
		
		ИзмененаСхемаКомпоновкиДанных(ЭтаФорма, ВыбранноеЗначение);
		
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Функция СформироватьСтруктуруВозврата()
	
	СтруктураВозврата = Новый Структура("АдресХранилищаНастройкиКомпоновщика, ИмяТекущегоШаблонаСКД");
	СтруктураВозврата.АдресХранилищаНастройкиКомпоновщика =  ПолучитьНастрокиКомпоновщика(КомпоновщикНастроек, УникальныйИдентификаторВладельца);
	СтруктураВозврата.ИмяТекущегоШаблонаСКД = ИмяТекущегоШаблонаСКД;
		
	Возврат СтруктураВозврата;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиОтборПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиОтборДоступныеПоляОтбораВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиПараметрыДанныхПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	Если РедактируемаяСхемаКомпоновкиДанныхМодифицированность Тогда
		
		Если Не НеПомещатьНастройкиВСхемуКомпоновкиДанных Тогда
			
			// Настройки компоновщика настроек помещаются в редактируемую схему
			ПоместитьНастройкиВСхемуКомпоновкиДанных(КомпоновщикНастроек, АдресРедактируемойСхемыКомпоновкиДанных);
			
		КонецЕсли;
		
		// Исходная схема замещается редактируемой схемой
		УстановитьСхемуКомпоновкиДанных(АдресИсходнойСхемыКомпоновкиДанных, АдресРедактируемойСхемыКомпоновкиДанных);
		
	Иначе
		
		// Настройки компоновщика настроек помещаются в исходную схему
		Если Не НеПомещатьНастройкиВСхемуКомпоновкиДанных Тогда
			
			ПоместитьНастройкиВСхемуКомпоновкиДанных(КомпоновщикНастроек, АдресИсходнойСхемыКомпоновкиДанных);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Модифицированность = Ложь;
	
	Если ВозвращатьИмяТекущегоШаблонаСКД И ЗначениеЗаполнено(УникальныйИдентификаторВладельца) Тогда
		
		Закрыть(СформироватьСтруктуруВозврата());
		
	ИначеЕсли ЗначениеЗаполнено(УникальныйИдентификаторВладельца) Тогда
		
		Закрыть(ПолучитьНастрокиКомпоновщика(КомпоновщикНастроек, УникальныйИдентификаторВладельца));
		
	Иначе
		
		Закрыть(Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьСхемуКомпоновки(Команда)
	
	ОткрытьКонструкторСхемыКомпоновкиДанных();
	
КонецПроцедуры

&НаКлиенте
Процедура ТекущийШаблонСхемыКомпоновкиДанныхОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение <> Неопределено И ВыбранноеЗначение <> ИмяТекущегоШаблонаСКД Тогда
		СтандартнаяОбработка = Ложь;
		ТекстВопроса = НСтр("en='Current settings will be lost. Continue?';ru='Текущие настройки будут потеряны. Продолжить?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ТекущийШаблонСхемыКомпоновкиДанныхОбработкаВыбораПродолжение", ЭтотОбъект, Новый Структура("ВыбранноеЗначение", ВыбранноеЗначение)), 
			ТекстВопроса, 
			РежимДиалогаВопрос.ДаНет,
			, 
			КодВозвратаДиалога.Нет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТекущийШаблонСхемыКомпоновкиДанныхОбработкаВыбораПродолжение(Результат, ДопПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если ВозвращатьПолноеИмяТекущегоШаблонаСКД Тогда
			НайденныеСтроки = Шаблоны.НайтиСтроки(Новый Структура("ПолноеИмя", ДопПараметры.ВыбранноеЗначение));
		Иначе
			НайденныеСтроки = Шаблоны.НайтиСтроки(Новый Структура("Имя", ДопПараметры.ВыбранноеЗначение));
		КонецЕсли;
		
		Если НайденныеСтроки.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("en='An error occurred while importing the template. Select another template.';ru='Ошибка загрузки шаблона. Выберите другой шаблон.'"),
				,"ТекущийШаблонСхемыКомпоновкиДанных");
			Возврат;
		КонецЕсли; 
		ЗагрузитьИзМакета(НайденныеСтроки[0].ПолноеИмяИсточникаШаблонов, НайденныеСтроки[0].Имя, КомпоновщикНастроек, АдресРедактируемойСхемыКомпоновкиДанных);
		Модифицированность = Истина;
		РедактируемаяСхемаКомпоновкиДанныхМодифицированность = Истина;
		ИмяТекущегоШаблонаСКД = ДопПараметры.ВыбранноеЗначение;
		
		ПустойЭлемент = Элементы.ТекущийШаблонСхемыКомпоновкиДанных.СписокВыбора.НайтиПоЗначению("");
		Если ПустойЭлемент <> Неопределено Тогда
			Элементы.ТекущийШаблонСхемыКомпоновкиДанных.СписокВыбора.Удалить(ПустойЭлемент);
		КонецЕсли;
		
	Иначе
		СтандартнаяОбработка = Ложь;
		ТекущийШаблонСхемыКомпоновкиДанных = ИмяТекущегоШаблонаСКД;
	КонецЕсли;
	
КонецПроцедуры


#Область ПроцедурыИФункцииОбщегоНазначения

&НаКлиенте
Процедура ОткрытьКонструкторСхемыКомпоновкиДанных()
	
	#Если ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
		
		// Настройки компоновщика настроек помещаются в редактируемую схему
		Если Не НеПомещатьНастройкиВСхемуКомпоновкиДанных Тогда
			ПоместитьНастройкиВСхемуКомпоновкиДанных(КомпоновщикНастроек, АдресРедактируемойСхемыКомпоновкиДанных);
		КонецЕсли;
		
		// Создается копия редактируемой схемы
		СхемаКомпоновкиДанных = СериализаторXDTO.ПрочитатьXDTO(СериализаторXDTO.ЗаписатьXDTO(ПолучитьИзВременногоХранилища(АдресРедактируемойСхемыКомпоновкиДанных)));
		
		// Копия редактируемой схемы открывается в конструкторе
		Конструктор = Новый КонструкторСхемыКомпоновкиДанных(СхемаКомпоновкиДанных);
		Конструктор.Редактировать(ЭтаФорма);
		
	#Иначе
		
		ПоказатьПредупреждение(Новый ОписаниеОповещения("ОткрытьКонструкторСхемыКомпоновкиДанныхЗавершение", ЭтотОбъект), НСтр("en='To edit the composition schema, run the configuration in the thick client mode.';ru='Для того, чтобы редактировать схему компоновки, необходимо запустить конфигурацию в режиме толстого клиента.'"));
		
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКонструкторСхемыКомпоновкиДанныхЗавершение(ДополнительныеПараметры) Экспорт
    
	Заглушка = Истина;    
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьXML(Значение)
	
	Запись = Новый ЗаписьXML();
	Запись.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьXML(Запись, Значение);
	Возврат Запись.Закрыть();
	
КонецФункции

&НаСервереБезКонтекста
Процедура УстановитьСхемуКомпоновкиДанных(АдресПриемник, АдресСхемаИсточник, ПроверятьНаИзменение = Ложь, БылиИзменения = Ложь)
	
	Если ЭтоАдресВременногоХранилища(АдресСхемаИсточник) Тогда
		
		СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемаИсточник);
		
	Иначе
		
		СхемаКомпоновкиДанных = АдресСхемаИсточник;
		
	КонецЕсли;
	
	Если ПроверятьНаИзменение Тогда
		
		БылиИзменения = Ложь;
		
		Если ЭтоАдресВременногоХранилища(АдресПриемник) Тогда
			
			ТекущаяСКД = ПолучитьИзВременногоХранилища(АдресПриемник);
			Если ТипЗнч(ТекущаяСКД) = Тип("СхемаКомпоновкиДанных") Тогда
				
				Если ПолучитьXML(СхемаКомпоновкиДанных) <> ПолучитьXML(ТекущаяСКД) Тогда
					
					БылиИзменения = Истина;
					
				КонецЕсли
				
			Иначе
				
				БылиИзменения = Истина;
				
			КонецЕсли;
			
		Иначе
			
			БылиИзменения = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоАдресВременногоХранилища(АдресПриемник) Тогда
		
		ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, АдресПриемник);
		
	Иначе
		
		АдресПриемник = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СкопироватьСхемуКомпоновкиДанных(АдресПриемник, АдресИсточник)
	
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресИсточник);
	
	Если ТипЗнч(СхемаКомпоновкиДанных) = Тип("СхемаКомпоновкиДанных") Тогда
		
		СхемаКомпоновкиДанных = СериализаторXDTO.ПрочитатьXDTO(СериализаторXDTO.ЗаписатьXDTO(СхемаКомпоновкиДанных));
		
	Иначе
		
		СхемаКомпоновкиДанных = Новый СхемаКомпоновкиДанных;
		
	КонецЕсли;
	
	Если ЭтоАдресВременногоХранилища(АдресПриемник) Тогда
		
		ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, АдресПриемник);
		
	Иначе
		
		АдресПриемник = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ИнициализироватьКомпоновщикНастроек(КомпоновщикНастроек, АдресСхемыКомпоновкиДанных, АдресНастроекКомпоновкиДанных = Неопределено)
	
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);
	Если ЗначениеЗаполнено(АдресНастроекКомпоновкиДанных) Тогда
		НастройкиКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресНастроекКомпоновкиДанных);
	КонецЕсли;
	
	Попытка
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных));
	Исключение
	КонецПопытки;
	
	Если ЗначениеЗаполнено(АдресНастроекКомпоновкиДанных) Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиКомпоновкиДанных);
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КонецЕсли;
	
	КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПоместитьНастройкиВСхемуКомпоновкиДанных(КомпоновщикНастроек, АдресСхемыКомпоновкиДанных)
	
	КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);
	
	КомпоновкаДанныхКлиентСервер.ОчиститьНастройкиКомпоновкиДанных(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КомпоновкаДанныхКлиентСервер.СкопироватьНастройкиКомпоновкиДанных(СхемаКомпоновкиДанных.НастройкиПоУмолчанию, КомпоновщикНастроек.Настройки);
	
	ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, АдресСхемыКомпоновкиДанных);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьНастрокиКомпоновщика(КомпоновщикНастроек, УникальныйИдентификатор)
	
	КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
	Возврат ПоместитьВоВременноеХранилище(КомпоновщикНастроек.ПолучитьНастройки(), УникальныйИдентификатор);
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗагрузитьИзМакета(ПолноеИмяИсточникаШаблонов, ИмяМакета, КомпоновщикНастроек, АдресСхемыКомпоновкиДанных)
	
	ПоместитьВоВременноеХранилище(ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяИсточникаШаблонов).ПолучитьМакет(ИмяМакета), АдресСхемыКомпоновкиДанных);
	ИнициализироватьКомпоновщикНастроек(КомпоновщикНастроек, АдресСхемыКомпоновкиДанных);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСхемуИзФайлаНаСервере(ТекстXML)
	
	Попытка
		
		ЧтениеXML = Новый ЧтениеXML();
		ЧтениеXML.УстановитьСтроку(ТекстXML);
		СхемаКомпоновкиДанных = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
		ИзмененаСхемаКомпоновкиДанных(ЭтаФорма, СхемаКомпоновкиДанных);
		
	Исключение
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСхемуИзФайлаНаСервереВеб(АдресФайлаВоВременномХранилище)
	
	Попытка
		
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресФайлаВоВременномХранилище);
		
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
		ДвоичныеДанные.Записать(ИмяВременногоФайла);
		
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.Прочитать(ИмяВременногоФайла, КодировкаТекста.UTF8);
		ТекстXML = ТекстовыйДокумент.ПолучитьТекст();
		
		ЧтениеXML = Новый ЧтениеXML();
		ЧтениеXML.УстановитьСтроку(ТекстXML);
		
		СхемаКомпоновкиДанных = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
		ИзмененаСхемаКомпоновкиДанных(ЭтаФорма, СхемаКомпоновкиДанных);
		
	Исключение
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСхемуИзФайла(Команда)
	
	ОбщегоНазначенияКлиент.ПредложитьУстановкуРасширенияРаботыСФайлами();
	
	НачатьПодключениеРасширенияРаботыСФайлами(Новый ОписаниеОповещения("ЗагрузитьСхемуИзФайлаЗавершение2", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСхемуИзФайлаЗавершение2(Подключено, ДополнительныеПараметры) Экспорт
    
    Если Подключено Тогда
        
        ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
        ВыборФайла.ПолноеИмяФайла = "";
        ВыборФайла.Заголовок = НСтр("en='Select a data composition schema';ru='Выбор схемы компоновки данных'");
        ВыборФайла.Фильтр = НСтр("en='Data composition schema (*.xml)|*.xml';ru='Схема компоновки данных (*.xml)|*.xml'");
        
        ВыборФайла.Показать(Новый ОписаниеОповещения("ЗагрузитьСхемуИзФайлаЗавершение1", ЭтотОбъект, Новый Структура("ВыборФайла", ВыборФайла)));
        
    Иначе
        
        #Если ВебКлиент Тогда
            
            АдресФайлаВоВременномХранилище = "";
            ИмяФайла = "";
            НачатьПомещениеФайла(Новый ОписаниеОповещения("ЗагрузитьСхемуИзФайлаЗавершение", ЭтотОбъект, Новый Структура("АдресФайлаВоВременномХранилище", АдресФайлаВоВременномХранилище)), АдресФайлаВоВременномХранилище, ИмяФайла, Истина, УникальныйИдентификатор);
            
        #КонецЕсли
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСхемуИзФайлаЗавершение1(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
    
    ВыборФайла = ДополнительныеПараметры.ВыборФайла;
    
    
    Если (ВыбранныеФайлы <> Неопределено) Тогда
        
        ТекстовыйДокумент = Новый ТекстовыйДокумент;
        ТекстовыйДокумент.Прочитать(ВыборФайла.ПолноеИмяФайла, КодировкаТекста.UTF8);
        Текст = ТекстовыйДокумент.ПолучитьТекст();
        
        ЗагрузитьСхемуИзФайлаНаСервере(Текст);
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСхемуИзФайлаЗавершение(Результат, Адрес, ИмяФайла, ДополнительныеПараметры) Экспорт
    
    АдресФайлаВоВременномХранилище = ДополнительныеПараметры.АдресФайлаВоВременномХранилище;
    
    
    Если НЕ Результат Тогда
        Возврат;
    КонецЕсли;
    
    ЗагрузитьСхемуИзФайлаНаСервереВеб(АдресФайлаВоВременномХранилище);

КонецПроцедуры

#КонецОбласти

#КонецОбласти
